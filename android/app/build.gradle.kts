// --- Agrega estas importaciones al inicio ---
import java.util.Properties
import java.io.FileInputStream
// --- ESTA ES LA IMPORTACIÓN QUE FALTABA ---
import org.gradle.api.JavaVersion

plugins {
    id("com.android.application")
    id("kotlin-android")
    // El plugin de Google Services se aplica aquí (sin versión)
    id("com.google.gms.google-services")
    // El Plugin de Flutter debe ir después de los de Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

// --- Inicio de la sección corregida (Sintaxis de Kotlin) ---

// 'def' se cambia por 'val'
val keystorePropertiesFile = rootProject.file("key.properties")
// 'new Properties()' se cambia por 'Properties()'
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    // 'new FileInputStream' se cambia por 'FileInputStream'
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// --- Fin de la sección corregida ---

android {
    namespace = "com.reconectate.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    signingConfigs {
        // 'release { ... }' se cambia por 'create("release") { ... }'
        create("release") {
            // Las comillas simples ('') se cambian por comillas dobles ("")
            // --- CORRECCIÓN DEL ERROR TIPOGRÁFICO AQUÍ ---
            // Se cambió 'keastoryProperties' y 'keastoreProperties' por 'keystoreProperties'
            if (keystoreProperties.getProperty("storeFile") != null) {
                // Se agrega el signo '=' para asignar las propiedades
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    compileOptions {
        // La sintaxis de versión de Java también se corrige
        // Esto ahora funcionará gracias a la importación
        // CORRECCIÓN: Es VERSION_11, no VERSION_1_11
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        // Esto ahora funcionará gracias a la importación
        // CORRECCIÓN: Es VERSION_11, no VERSION_1_11
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.reconectate.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        // Se usa 'getByName("release")'
        getByName("release") {
            // Se asigna con '=' y se usa 'getByName'
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
 //crashlist
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'

