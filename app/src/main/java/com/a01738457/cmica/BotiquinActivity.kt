package com.a01738457.cmica

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.a01738457.cmica.ui.theme.CmicaTheme

class BotiquinActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            Surface(
                modifier = Modifier.fillMaxSize(),
                color = Color.White
            ) {
                BotiquinScreen()
            }
        }
    }
}

@Composable
fun BotiquinScreen() {
    var page by remember { mutableIntStateOf(0) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFF2F2F7)) // systemGroupedBackground
    ) {
        // Header
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = "Botiquín de Camila",
                fontSize = 18.sp,
                fontWeight = FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.weight(1f))
            Icon(
                painter = painterResource(id = R.drawable.ic_globe),
                contentDescription = "Globe",
                modifier = Modifier.size(24.dp)
            )
        }

        // Paginado (simulación con estado)
        when (page) {
            0 -> Botiquin1Page(onNextPage = { page = 1 })
            1 -> Botiquin2Page()
        }

        Spacer(modifier = Modifier.weight(1f))

        NavigationBar()
    }
}

@Composable
fun Botiquin1Page(onNextPage: () -> Unit) {
    Column(
        modifier = Modifier
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 16.dp, vertical = 12.dp)
    ) {
        // Card: Agregar Medicamento
        CardStyle {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text("Agregar Medicamento", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)

                LabeledField("Nombre:")
                LabeledField("Dosis:")
                LabeledField("Cada cuánto:")
                LabeledField("Durante:")
                LabeledField("Fecha de Caducidad:")

                Button(
                    onClick = { onNextPage() },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 4.dp)
                ) {
                    Text("Agregar", fontSize = 16.sp)
                }
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Card: Medicamentos
        CardStyle {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text("Medicamentos", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)

                Column(
                    modifier = Modifier
                        .background(Color(0xFFF2F2F7), RoundedCornerShape(10.dp))
                        .padding(12.dp)
                ) {
                    Text("Adrenalina", fontSize = 16.sp, fontWeight = FontWeight.Bold)
                    InfoRow("Dosis", "5 mg")
                    InfoRow("Cada cuánto:", "Cada 8 hrs")
                    InfoRow("Durante", "5 días")
                    InfoRow("Fecha de Caducidad:", "30/08/2025", accent = Color.Red)
                }
            }
        }
    }
}

@Composable
fun Botiquin2Page() {
    Column(
        modifier = Modifier
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 16.dp, vertical = 12.dp)
    ) {
        // Card: Agregar Receta Médica
        CardStyle {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text("Agregar Receta Médica", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)

                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color(0xFFF2F2F7), RoundedCornerShape(10.dp))
                        .padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Subir Receta", color = Color.Gray)
                    Spacer(modifier = Modifier.weight(1f))
                    Icon(
                        painter = painterResource(id = R.drawable.ic_upload),
                        contentDescription = "Subir",
                        modifier = Modifier.size(24.dp)
                    )
                }

                LabeledField("Fecha")

                Button(onClick = {}) {
                    Text("Agregar")
                }
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Card: Imagen + Fecha
        CardStyle {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text("Imagen", fontSize = 14.sp)

                Box(
                    modifier = Modifier
                        .background(Color(0xFFF2F2F7), RoundedCornerShape(10.dp))
                        .padding(12.dp)
                ) {
                    Image(
                        painter = painterResource(id = R.drawable.receta),
                        contentDescription = "Receta",
                        contentScale = ContentScale.Crop,
                        modifier = Modifier
                            .clip(RoundedCornerShape(8.dp))
                            .fillMaxWidth()
                            .height(150.dp)
                    )
                }

                Text("Fecha", fontSize = 14.sp)

                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color(0xFFF2F2F7), RoundedCornerShape(10.dp))
                        .padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("30/08/2025")
                    Spacer(modifier = Modifier.weight(1f))
                }
            }
        }
    }
}

@Composable
fun LabeledField(label: String) {
    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        Text(label, fontSize = 14.sp)
        OutlinedTextField(
            value = "",
            onValueChange = {},
            modifier = Modifier
                .fillMaxWidth()
                .height(40.dp),
            singleLine = true
        )
    }
}

@Composable
fun InfoRow(left: String, right: String, accent: Color? = null) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(left, fontSize = 14.sp)
        Spacer(modifier = Modifier.weight(1f))
        Text(right, fontSize = 14.sp, color = accent ?: Color.Black)
    }
}

@Composable
fun CardStyle(content: @Composable ColumnScope.() -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(bottom = 12.dp)
            .background(Color.White, RoundedCornerShape(12.dp))
            .shadow(6.dp, RoundedCornerShape(12.dp))
            .padding(16.dp),
        content = content
    )
}

@Composable
fun NavigationBar() {
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
fun BotiquinScreenPreview() {
    CmicaTheme {
        BotiquinScreen()
    }
}