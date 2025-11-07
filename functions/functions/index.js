const functions = require('firebase-functions');
const admin = require('firebase-admin');

// 🚨 1. Inicializa el SDK de Firebase Admin
// Esto permite que la función interactúe con Auth y Firestore.
admin.initializeApp();
const db = admin.firestore();

// 🚨 2. Configura SendGrid
// Usamos una variable de entorno para guardar la clave de forma segura.
// Deberás establecer esta variable en el paso de configuración.
const sgMail = require('@sendgrid/mail');
const SENDGRID_API_KEY = functions.config().sendgrid.key;
sgMail.setApiKey(SENDGRID_API_KEY);

const SENDER_EMAIL = 'tu-correo-verificado@ejemplo.com'; // 🚨 REEMPLAZA CON TU EMAIL VERIFICADO EN SENDGRID
const OTP_EXPIRATION_SECONDS = 180; // 3 minutos

// --- FUNCIÓN PARA ENVIAR Y REGISTRAR OTP ---
exports.sendOtpEmail = functions.https.onCall(async (data, context) => {
    const { email, password, name, isResend } = data;

    if (!email) {
        throw new functions.https.HttpsError('invalid-argument', 'El correo es obligatorio.');
    }

    // 1. GENERAR CÓDIGO OTP (6 dígitos)
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    let userId;
    let userRecord;

    try {
        // Intenta obtener el usuario. Si no existe, lo crea (solo si no es un reenvío)
        userRecord = await admin.auth().getUserByEmail(email);
        userId = userRecord.uid;

    } catch (error) {
        // Si el usuario no existe, lo creamos.
        if (error.code === 'auth/user-not-found' && !isResend) {
            userRecord = await admin.auth().createUser({ email, password, displayName: name, disabled: false });
            userId = userRecord.uid;
        } else if (error.code === 'auth/user-not-found' && isResend) {
             throw new functions.https.HttpsError('not-found', 'Usuario no encontrado para reenvío.');
        } else {
             throw new functions.https.HttpsError('internal', 'Error de autenticación.', error);
        }
    }

    // 2. GUARDAR OTP Y EXPIRACIÓN EN FIRESTORE
    const expirationTime = admin.firestore.Timestamp.fromMillis(Date.now() + (OTP_EXPIRATION_SECONDS * 1000));

    // Guardamos el código OTP en Firestore para verificarlo después
    await db.collection('pending_verifications').doc(userId).set({
        otpCode: otpCode,
        email: email,
        expiration: expirationTime,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // 3. ENVIAR EMAIL CON SENDGRID
    const msg = {
        to: email,
        from: SENDER_EMAIL,
        subject: 'Tu Código de Verificación Re-Conectate',
        html: `
            <h1>Verificación de Cuenta</h1>
            <p>Tu código de verificación es:</p>
            <h2 style="color: #D32F2F;">${otpCode}</h2>
            <p>Este código expira en ${OTP_EXPIRATION_SECONDS / 60} minutos.</p>
        `,
    };

    try {
        await sgMail.send(msg);
    } catch (error) {
        console.error("Error al enviar el email con SendGrid:", error);
        // Devolvemos éxito de todos modos para no interrumpir el flujo si la función creó el usuario
    }

    return { success: true, message: 'OTP enviado exitosamente.', userId: userId };
});


// --- FUNCIÓN PARA VERIFICAR OTP ---
exports.verifyOtpCode = functions.https.onCall(async (data, context) => {
    const { email, otpCode } = data;

    if (!email || !otpCode) {
         throw new functions.https.HttpsError('invalid-argument', 'Email y OTP son obligatorios.');
    }

    let user;
    try {
        user = await admin.auth().getUserByEmail(email);
    } catch (error) {
        throw new functions.https.HttpsError('unauthenticated', 'Usuario no encontrado.');
    }

    const userId = user.uid;

    const verificationDoc = await db.collection('pending_verifications').doc(userId).get();

    if (!verificationDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Solicitud de OTP no encontrada o ya expiró.');
    }

    const verificationData = verificationDoc.data();

    // 1. Comprobar Expiración
    const now = admin.firestore.Timestamp.now();
    if (verificationData.expiration.toDate() < now.toDate()) {
        await verificationDoc.ref.delete(); // Limpia el expirado
        throw new functions.https.HttpsError('permission-denied', 'El código OTP ha expirado.');
    }

    // 2. Comprobar Código
    if (verificationData.otpCode !== otpCode) {
        throw new functions.https.HttpsError('unauthenticated', 'Código OTP incorrecto.');
    }

    // 3. Éxito: Marcar la cuenta como verificada y limpiar
    await admin.auth().updateUser(userId, { emailVerified: true });
    await verificationDoc.ref.delete();

    return { success: true, message: 'Usuario verificado y autenticado.' };
});
```

### Paso 3: Configurar la Clave de SendGrid (Secreto)

Antes de desplegar, debes decirle a Firebase tu clave de SendGrid de forma segura (sin meterla en el código).

Ejecuta este comando en la terminal **dentro de la carpeta `functions`**:

```bash
firebase functions:config:set sendgrid.key="TU_CLAVE_API_DE_SENDGRID"
```

### Paso 4: Desplegar a Firebase

Finalmente, despliega tus funciones. Asegúrate de estar en la raíz de tu proyecto (un directorio *antes* de la carpeta `functions`).

```bash
firebase deploy --only functions