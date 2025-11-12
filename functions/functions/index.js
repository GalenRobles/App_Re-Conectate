/**
 * Firebase Cloud Function para enviar la OTP a través de EmailJS.
 *
 * Esta función actúa como un proxy de backend para evitar la restricción de EmailJS
 * que bloquea las llamadas directas desde aplicaciones móviles.
 */
const functions = require('firebase-functions');
const axios = require('axios'); // Asegúrate de instalar axios: npm install axios

// Las credenciales de EmailJS deben almacenarse de forma segura en las variables de entorno de Firebase.
// Ejecuta este comando en tu terminal para configurar las variables:
// firebase functions:config:set emailjs.service_id="TU_SERVICE_ID" emailjs.template_id="TU_TEMPLATE_ID" emailjs.user_id="TU_USER_ID"

// URL del endpoint de EmailJS
const EMAILJS_URL = 'https://api.emailjs.com/api/v1.0/email/send';

// -----------------------------------------------------------------------------
// Función HTTP Callable: Invocada directamente desde la aplicación Flutter/Dart
// -----------------------------------------------------------------------------

exports.sendOtpEmailProxy = functions.https.onCall(async (data, context) => {
    // 1. Verificar autenticación (Asegura que solo usuarios autenticados puedan llamar)
    if (!context.auth) {
        throw new functions.https.HttpsError(
            'unauthenticated',
            'Solo usuarios autenticados pueden solicitar una OTP.'
        );
    }

    // 2. Validar datos de entrada
    const recipientEmail = data.recipientEmail;
    const otpCode = data.otpCode;
    const expiresTime = data.expiresTime;

    if (!recipientEmail || !otpCode || !expiresTime) {
        throw new functions.https.HttpsError(
            'invalid-argument',
            'Faltan parámetros de correo (recipientEmail, otpCode, expiresTime).'
        );
    }

    // Obtener credenciales de las variables de entorno de Firebase
    const serviceId = functions.config().emailjs.service_id;
    const templateId = functions.config().emailjs.template_id;
    const userId = functions.config().emailjs.user_id;

    if (!serviceId || !templateId || !userId) {
        console.error("ERROR: Las credenciales de EmailJS no están configuradas en las variables de entorno de Firebase.");
        throw new functions.https.HttpsError(
            'internal',
            'La configuración del servicio de correo no es válida.'
        );
    }

    try {
        // 3. Preparar el cuerpo de la solicitud para EmailJS
        const emailjsPayload = {
            service_id: serviceId,
            template_id: templateId,
            user_id: userId,
            template_params: {
                to_email: recipientEmail,
                otp_code: otpCode,        // El código generado en Dart/Flutter
                time: expiresTime,        // La hora de expiración
            },
        };

        // 4. Llamar a la API de EmailJS desde el servidor (Proxy)
        const response = await axios.post(EMAILJS_URL, emailjsPayload, {
            headers: {
                'Content-Type': 'application/json',
            },
        });

        // 5. Verificar la respuesta de EmailJS
        if (response.status === 200) {
            console.log(`OTP enviada exitosamente a ${recipientEmail}`);
            return { success: true, message: 'Correo OTP enviado.' };
        } else {
            console.error(`Fallo de EmailJS (Status: ${response.status}): ${response.data}`);
            throw new functions.https.HttpsError(
                'unavailable',
                `Fallo al enviar el correo: ${response.data}`
            );
        }

    } catch (error) {
        // Manejar errores de red o errores lanzados por axios
        console.error('Error al llamar a EmailJS desde la función:', error.message);
        throw new functions.https.HttpsError(
            'internal',
            'Error interno del servidor al procesar el envío de correo.'
        );
    }
});