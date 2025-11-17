package com.a01738457.cmica

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.compose.animation.core.*
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.a01738457.cmica.data.entities.TipoAccion
import com.a01738457.cmica.viewmodel.AppViewModel
import kotlin.math.roundToInt

@Composable
fun SOSDragButton(
    viewModel: AppViewModel,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val currentUser by viewModel.currentUser.collectAsState()

    // Estados para el arrastre
    var offsetY by remember { mutableStateOf(0f) }
    val limiteActivacion = -80f // Debe subir 80dp para activar

    // Animación de rebote
    val animatedOffsetY by animateFloatAsState(
        targetValue = offsetY,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioMediumBouncy,
            stiffness = Spring.StiffnessLow
        ),
        label = "SOS Button Animation"
    )

    // Función para activar SOS
    fun activarSOS() {
        // Vibración háptica
        val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createOneShot(200, VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(200)
        }

        currentUser?.let { user ->
            // Crear notificación
            val isEnglish = user.idiomaSeleccionado == "English"
            val notiDetail = if (isEnglish) {
                "Emergency alert activated via slider button"
            } else {
                "Se ha activado la alerta de emergencia mediante el botón deslizante"
            }

            viewModel.insertAccion(TipoAccion.SOS_CALL, notiDetail)

            // Preparar mensaje de emergencia
            val mensajeEmergencia = if (isEnglish) {
                """
                HELP! I am ${user.nombre}. I am having a possible episode of ANAPHYLAXIS.
                Location: (Current Location)
                Blood Type: ${user.tipoSangre}
                Allergies: ${user.alergias}
                Diagnosis: ${user.diagnostico}
                """.trimIndent()
            } else {
                """
                ¡AYUDA! soy ${user.nombre}. Estoy teniendo un posible episodio de ANAFILAXIA.
                Ubicación: (Ubicación Actual)
                Sangre: ${user.tipoSangre}
                Alergias: ${user.alergias}
                Diagnóstico: ${user.diagnostico}
                """.trimIndent()
            }

            // Limpiar número de teléfono
            val numeroLimpio = user.contactoEmergencia.filter { it.isDigit() }

            println("Intentando contactar a: $numeroLimpio")
            println("Mensaje preparado: $mensajeEmergencia")

            // Realizar llamada
            try {
                val intent = Intent(Intent.ACTION_CALL).apply {
                    data = Uri.parse("tel:$numeroLimpio")
                }
                context.startActivity(intent)
            } catch (e: Exception) {
                // Si falla ACTION_CALL, intentar con ACTION_DIAL
                val intent = Intent(Intent.ACTION_DIAL).apply {
                    data = Uri.parse("tel:$numeroLimpio")
                }
                context.startActivity(intent)
            }
        }
    }

    Box(
        modifier = modifier
            .size(60.dp)
            .offset { IntOffset(0, animatedOffsetY.roundToInt()) }
            .pointerInput(Unit) {
                detectDragGestures(
                    onDragEnd = {
                        // Verificar si llegó al límite
                        if (offsetY <= limiteActivacion) {
                            activarSOS()
                        }
                        // Regresar a posición original
                        offsetY = 0f
                    },
                    onDrag = { change, dragAmount ->
                        change.consume()
                        val newOffsetY = offsetY + dragAmount.y
                        // Solo permitir arrastrar hacia arriba y máximo -150
                        if (newOffsetY < 0 && newOffsetY > -150) {
                            offsetY = newOffsetY
                        }
                    }
                )
            },
        contentAlignment = Alignment.Center
    ) {
        // Flecha indicadora cuando se empieza a arrastrar
        if (offsetY < -10f) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.offset(y = (-30).dp)
            ) {
                Icon(
                    painter = painterResource(id = R.drawable.ic_chevron_up),
                    contentDescription = "Drag up",
                    tint = Color.Red.copy(alpha = 0.5f),
                    modifier = Modifier.size(16.dp)
                )
            }
        }

        // Botón SOS
        Surface(
            modifier = Modifier.size(60.dp),
            shape = CircleShape,
            color = Color(0xFFFF5252).copy(alpha = 0.8f),
            shadowElevation = 6.dp
        ) {
            Box(
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "SOS",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = Color.White
                )
            }
        }
    }
}