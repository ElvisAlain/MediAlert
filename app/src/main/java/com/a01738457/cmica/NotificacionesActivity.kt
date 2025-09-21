package com.a01738457.cmica

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.a01738457.cmica.ui.theme.CmicaTheme

class NotificacionesActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CmicaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = Color.White
                ) {
                    NotificacionesScreen()
                }
            }
        }
    }
}

@Composable
fun NotificacionesScreen() {
    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Encabezado
        NotificacionesHeader()

        // Lista de tarjetas de notificación
        LazyColumn(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
            contentPadding = PaddingValues(bottom = 8.dp)
        ) {
            item {
                NotiCard(
                    titulo = "¡Tu medicamento está por caducar!",
                    detalle = "La fecha de caducidad de “_medicamento_” es: “00/00/0000” → 1 semana antes",
                    trailing = {
                        Image(
                            painter = painterResource(id = R.drawable.ic_calendar_filled),
                            contentDescription = "Ícono de calendario",
                            modifier = Modifier.size(40.dp)
                        )
                    }
                )
            }
            item {
                NotiCard(
                    titulo = "¡Completa tus datos!",
                    detalle = "No olvides llenar los campos de Datos Personales, tu información es muy importante.\n→ Únicamente si te falta llenar información",
                    trailing = {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_info_circle),
                            contentDescription = "Ícono de información",
                            modifier = Modifier.size(40.dp),
                            tint = Color.Gray
                        )
                    }
                )
            }
            item {
                NotiCard(
                    titulo = "Botón SOS activado",
                    detalle = "Has llamado al 911, se ha mandado mensaje a tu contacto de emergencia → cuando se presione el botón SOS",
                    trailing = {
                        Image(
                            painter = painterResource(id = R.drawable.ic_phone_filled), // <-- Se cambió a Image y se quitó el Box y Text
                            contentDescription = "Ícono de llamada SOS",
                            modifier = Modifier.size(40.dp)
                        )
                    }
                )
            }
            item {
                NotiCard(
                    titulo = "¡Es momento de tomar tu medicamento!",
                    detalle = "No olvides tomar “_dosis_” de tu medicamento: “_medicamento_”.",
                    trailing = {
                        Image(
                            painter = painterResource(id = R.drawable.ic_pills_filled),
                            contentDescription = "Ícono de medicamento",
                            modifier = Modifier.size(40.dp)
                        )
                    }
                )
            }
        }

        // Barra Inferior de Navegación
        NotificacionesBottomBar()
    }
}

@Composable
fun NotificacionesHeader() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            painter = painterResource(id = R.drawable.ic_bell_filled),
            contentDescription = "Notificaciones",
            modifier = Modifier.size(24.dp)
        )
        Text(
            text = "Notificaciones",
            fontSize = 20.sp,
            fontWeight = FontWeight.SemiBold,
            modifier = Modifier.padding(start = 8.dp)
        )
        Spacer(modifier = Modifier.weight(1f))

        Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
            Icon(
                painter = painterResource(id = R.drawable.ic_cross_case),
                contentDescription = "Cross Case",
                modifier = Modifier.size(24.dp)
            )
            Icon(
                painter = painterResource(id = R.drawable.ic_globe),
                contentDescription = "Globe",
                modifier = Modifier.size(24.dp)
            )
        }
    }
}

@Composable
fun NotiCard(titulo: String, detalle: String, trailing: @Composable () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(4.dp, RoundedCornerShape(18.dp))
            .background(Color(0xFFE0E0E0), RoundedCornerShape(18.dp))
            .padding(14.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.Top
    ) {
        Column(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Text(
                text = titulo,
                fontWeight = FontWeight.Bold,
                fontSize = 16.sp
            )
            Text(
                text = detalle,
                fontSize = 14.sp,
                color = Color.Gray
            )
        }
        Spacer(modifier = Modifier.width(12.dp))
        trailing()
    }
}

@Composable
fun NotificacionesBottomBar() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(Color.White)
            .padding(vertical = 10.dp)
            .shadow(4.dp),
        horizontalArrangement = Arrangement.SpaceAround,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            painter = painterResource(id = R.drawable.ic_house_filled),
            contentDescription = "Inicio",
            modifier = Modifier.size(32.dp)
        )
        Icon(
            painter = painterResource(id = R.drawable.ic_bell_filled),
            contentDescription = "Notificaciones",
            modifier = Modifier.size(32.dp)
        )
        Box(
            modifier = Modifier
                .size(60.dp)
                .shadow(4.dp, CircleShape)
                .background(Color.White, CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = "SOS",
                fontWeight = FontWeight.Bold,
                fontSize = 18.sp,
                color = Color(0xFFE53935)
            )
        }
        Icon(
            painter = painterResource(id = R.drawable.ic_book_filled),
            contentDescription = "Manual",
            modifier = Modifier.size(32.dp)
        )
        Icon(
            painter = painterResource(id = R.drawable.ic_person_circle_filled),
            contentDescription = "Perfil",
            modifier = Modifier.size(32.dp)
        )
    }
}

@Preview(showBackground = true)
@Composable
fun NotificacionesScreenPreview() {
    CmicaTheme {
        NotificacionesScreen()
    }
}