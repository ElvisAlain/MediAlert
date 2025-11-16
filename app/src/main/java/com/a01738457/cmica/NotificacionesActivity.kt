package com.a01738457.cmica

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.a01738457.cmica.ui.theme.CmicaTheme
import java.text.SimpleDateFormat
import java.util.*

class NotificacionesActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            CmicaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.surfaceVariant
                ) {
                    NotificacionesScreen()
                }
            }
        }
    }
}

enum class TipoAccion {
    PROFILE_UPDATE,
    SOS_CALL
}

data class HistorialAcciones(
    val id: String = UUID.randomUUID().toString(),
    val tipo_accion: TipoAccion,
    val detalle: String,
    val fecha_hora: Date = Date(),
    var leida: Boolean = false
)

@Composable
fun NotificacionesScreen() {
    val context = LocalContext.current

    // Estados
    var isEnglish by remember { mutableStateOf(false) }
    var userName by remember { mutableStateOf("Camila") }

    var notificaciones by remember {
        mutableStateOf(
            listOf(
                HistorialAcciones(
                    tipo_accion = TipoAccion.PROFILE_UPDATE,
                    detalle = "No olvides llenar los campos de Datos Personales, tu información es muy importante.",
                    fecha_hora = Date(),
                    leida = false
                ),
                HistorialAcciones(
                    tipo_accion = TipoAccion.SOS_CALL,
                    detalle = "Has llamado al 911, se ha mandado mensaje a tu contacto de emergencia.",
                    fecha_hora = Calendar.getInstance().apply { add(Calendar.HOUR, -2) }.time,
                    leida = false
                )
            )
        )
    }

    LaunchedEffect(Unit) {
        notificaciones = notificaciones.map { it.copy(leida = true) }
    }

    val sortedNotificaciones = notificaciones.sortedByDescending { it.fecha_hora }

    Scaffold(
        bottomBar = { BottomTabBarNotificaciones() }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.surfaceVariant)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    painter = painterResource(id = R.drawable.ic_bell_filled),
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(Modifier.width(6.dp))
                Text(
                    text = if (isEnglish) "Notifications" else "Notificaciones",
                    fontSize = 20.sp,
                    fontWeight = FontWeight.SemiBold
                )
                Spacer(Modifier.weight(1f))
                LanguageDropdownNotificaciones(
                    isEnglish = isEnglish,
                    onLanguageChange = { isEnglish = it }
                )
            }

            if (sortedNotificaciones.isEmpty()) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = if (isEnglish)
                            "You have no new notifications."
                        else
                            "No tienes notificaciones nuevas.",
                        color = Color.Gray,
                        fontSize = 16.sp
                    )
                }
            } else {
                LazyColumn(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                        .padding(horizontal = 16.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp),
                    contentPadding = PaddingValues(vertical = 12.dp)
                ) {
                    items(sortedNotificaciones) { notificacion ->
                        NotiCardView(
                            notificacion = notificacion,
                            isEnglish = isEnglish
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun NotiCardView(
    notificacion: HistorialAcciones,
    isEnglish: Boolean
) {
    val (titulo, trailing) = when (notificacion.tipo_accion) {
        TipoAccion.PROFILE_UPDATE -> {
            val title = if (isEnglish) "Complete Your Data!" else "¡Completa Tus Datos!"
            val icon: @Composable () -> Unit = {
                Icon(
                    painter = painterResource(id = R.drawable.ic_info_circle),
                    contentDescription = "Info",
                    modifier = Modifier.size(40.dp),
                    tint = Color.Gray
                )
            }
            title to icon
        }
        TipoAccion.SOS_CALL -> {
            val title = if (isEnglish) "SOS Button Activated" else "Botón SOS Activado"
            val icon: @Composable () -> Unit = {
                Box(
                    modifier = Modifier.size(40.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_phone_radiowaves),
                        contentDescription = "SOS",
                        modifier = Modifier.size(40.dp),
                        tint = Color(0xFF9C27B0) // Purple
                    )
                    Box(
                        modifier = Modifier
                            .size(20.dp)
                            .offset(x = 14.dp, y = (-12).dp)
                            .clip(CircleShape)
                            .background(Color.Red),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "911",
                            color = Color.White,
                            fontSize = 8.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
            title to icon
        }
    }

    NotiCard(
        titulo = titulo,
        detalle = notificacion.detalle,
        trailing = trailing
    )
}

@Composable
fun NotiCard(
    titulo: String,
    detalle: String,
    trailing: @Composable () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(
                elevation = 6.dp,
                shape = RoundedCornerShape(18.dp),
                clip = false
            )
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
                fontSize = 16.sp,
                color = Color.Black
            )
            Text(
                text = detalle,
                fontSize = 14.sp,
                color = Color.Gray,
                lineHeight = 20.sp
            )
        }
        Spacer(modifier = Modifier.width(12.dp))
        trailing()
    }
}

@Composable
fun LanguageDropdownNotificaciones(
    isEnglish: Boolean,
    onLanguageChange: (Boolean) -> Unit
) {
    var expanded by remember { mutableStateOf(false) }

    Box {
        Icon(
            painter = painterResource(id = R.drawable.ic_globe),
            contentDescription = if (isEnglish) "Language" else "Idioma",
            modifier = Modifier
                .size(24.dp)
                .clickable { expanded = true }
        )

        DropdownMenu(
            expanded = expanded,
            onDismissRequest = { expanded = false }
        ) {
            DropdownMenuItem(
                text = { Text("Español") },
                onClick = {
                    onLanguageChange(false)
                    expanded = false
                }
            )
            DropdownMenuItem(
                text = { Text("English") },
                onClick = {
                    onLanguageChange(true)
                    expanded = false
                }
            )
        }
    }
}

@Composable
fun BottomTabBarNotificaciones() {
    val context = LocalContext.current

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            painter = painterResource(id = R.drawable.ic_house_filled),
            contentDescription = "Home",
            modifier = Modifier
                .size(24.dp)
                .clickable {
                    context.startActivity(Intent(context, MainActivity::class.java))
                }
        )
        Icon(
            painter = painterResource(id = R.drawable.ic_bell_filled),
            contentDescription = "Notificaciones",
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(24.dp)
        )

        Box(
            modifier = Modifier
                .size(56.dp)
                .clip(CircleShape)
                .background(Color(0xFFFF5252))
                .clickable { /* TODO: SOS */ },
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = "SOS",
                fontWeight = FontWeight.Bold,
                color = Color.White,
                fontSize = 16.sp
            )
        }

        Icon(
            painter = painterResource(id = R.drawable.ic_book_filled),
            contentDescription = "Guía",
            modifier = Modifier
                .size(24.dp)
                .clickable {
                    context.startActivity(Intent(context, GuiasActivity::class.java))
                }
        )
        Icon(
            painter = painterResource(id = R.drawable.ic_person_circle_filled),
            contentDescription = "Perfil",
            modifier = Modifier
                .size(24.dp)
                .clickable {
                    context.startActivity(Intent(context, DatosPersonalesActivity::class.java))
                }
        )
    }
}

@Composable
fun NotificacionesBellView(
    notificacionesNoLeidas: Int,
    onClick: () -> Unit = {}
) {
    Box(
        modifier = Modifier
            .size(24.dp)
            .clickable { onClick() }
    ) {
        Icon(
            painter = painterResource(id = R.drawable.ic_bell_filled),
            contentDescription = "Notificaciones",
            modifier = Modifier
                .size(24.dp)
                .padding(top = 5.dp, end = 5.dp)
        )

        if (notificacionesNoLeidas > 0) {
            Box(
                modifier = Modifier
                    .size(18.dp)
                    .align(Alignment.TopEnd)
                    .offset(x = 5.dp, y = (-5).dp)
                    .clip(CircleShape)
                    .background(Color.Red),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = notificacionesNoLeidas.toString(),
                    color = Color.White,
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold
                )
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun NotificacionesScreenPreview() {
    CmicaTheme {
        NotificacionesScreen()
    }
}