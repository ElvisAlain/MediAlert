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

class DatosPersonalesActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CmicaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = Color.White
                ) {
                    DatosPersonalesScreen()
                }
            }
        }
    }
}

@Composable
fun DatosPersonalesScreen() {
    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Barra Superior
        TopBar()

        // Contenido Principal (Perfil y Datos)
        Column(
            modifier = Modifier.weight(1f) // Ocupa el espacio restante
        ) {
            PerfilSection()
            Spacer(modifier = Modifier.height(16.dp))
            DatosChipsSection()
        }

        // Barra Inferior de Navegación
        BottomBar()
    }
}

@Composable
fun TopBar() {
    // La barra superior del diseño, con los íconos y el título
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            painter = painterResource(id = R.drawable.ic_localization),
            contentDescription = "Información",
            modifier = Modifier.size(24.dp)
        )
        Text(
            text = "Datos Personales",
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
fun PerfilSection() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Image(
            painter = painterResource(id = R.drawable.ic_person_circle_filled),
            contentDescription = "Foto de perfil de Camila",
            modifier = Modifier
                .size(56.dp)
                .clip(CircleShape)
                .background(Color.LightGray)
        )
        Spacer(modifier = Modifier.width(12.dp))
        Text(
            text = "Camila",
            fontSize = 24.sp,
            fontWeight = FontWeight.SemiBold
        )
        Spacer(modifier = Modifier.width(8.dp))
        Icon(
            painter = painterResource(id = R.drawable.ic_pencil_fill), // Usando el ícono sugerido
            contentDescription = "Editar nombre",
            modifier = Modifier.size(24.dp)
        )
        Spacer(modifier = Modifier.weight(1f))
    }
}

@Composable
fun DatosChipsSection() {
    // La lista de datos personales en formato de "chips"
    LazyColumn(
        modifier = Modifier.fillMaxWidth(),
        contentPadding = PaddingValues(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp)
    ) {
        item { ChipRow(titulo = "Nombre:", valor = "Camila") }
        item { ChipRow(titulo = "Apellidos:", valor = "Juárez") }
        item { ChipRow(titulo = "Teléfono:", valor = "2354687958") }
        item { ChipRow(titulo = "Contacto Emergencias:", valor = "2368545879") }
        item { ChipRow(titulo = "Dirección:", valor = "Avenida José María") }
        item { ChipRow(titulo = "Sexo:", valor = "Mujer") }
        item { ChipRow(titulo = "Peso:", valor = "60 Kg") }
        item { ChipRow(titulo = "Edad:", valor = "30 años") }
        item { ChipRow(titulo = "Tipo de sangre:", valor = "O+") }
        item { ChipRow(titulo = "Diagnóstico:", valor = "Asma") }
        item { ChipRow(titulo = "Alergias:", valor = "Polvo, polen, ...") }
    }
}

@Composable
fun ChipRow(titulo: String, valor: String) {
    // La estructura de cada "chip" individual
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(2.dp, RoundedCornerShape(50))
            .background(Color(0xFFE0E0E0), RoundedCornerShape(50))
            .padding(horizontal = 14.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = titulo,
            fontWeight = FontWeight.SemiBold,
            color = Color(0xFF0D47A1),
            fontSize = 16.sp
        )
        Spacer(modifier = Modifier.width(4.dp))
        Text(
            text = valor,
            fontSize = 16.sp
        )
        Spacer(modifier = Modifier.weight(1f))
        Icon(
            painter = painterResource(id = R.drawable.ic_pencil_fill),
            contentDescription = "Editar",
            tint = Color.Gray,
            modifier = Modifier.size(20.dp)
        )
    }
}

@Composable
fun BottomBar() {
    // La barra de navegación inferior
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
fun DatosPersonalesScreenPreview() {
    CmicaTheme {
        DatosPersonalesScreen()
    }
}