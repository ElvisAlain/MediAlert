package com.a01738457.cmica

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.a01738457.cmica.ui.theme.CmicaTheme

class GuiasActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            CmicaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = Color.White
                ) {
                    GuiasScreen()
                }
            }
        }
    }
}

@Composable
fun GuiasScreen() {
    var page by remember { mutableIntStateOf(0) }

    Scaffold(
        bottomBar = { BottomTabBar() }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .background(MaterialTheme.colorScheme.surfaceVariant)
        ) {
            // HEADER
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    painter = painterResource(id = R.drawable.ic_book_filled),
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(Modifier.width(6.dp))
                Text("Guía", fontSize = 20.sp, fontWeight = FontWeight.SemiBold)
                Spacer(Modifier.weight(1f))
                Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_cross_case),
                        contentDescription = "Botiquín",
                        modifier = Modifier.size(24.dp)
                    )
                    Icon(
                        painter = painterResource(id = R.drawable.ic_globe),
                        contentDescription = "Globo",
                        modifier = Modifier.size(24.dp)
                    )
                }
            }

            // TABVIEW
            TabRow(selectedTabIndex = page) {
                Tab(selected = page == 0, onClick = { page = 0 }, text = { Text("Síntomas") })
                Tab(selected = page == 1, onClick = { page = 1 }, text = { Text("Qué hacer") })
            }

            when (page) {
                0 -> GuiaSintomasPage()
                1 -> GuiaQueHacerPage()
            }
        }
    }
}

@Composable
fun BottomTabBar() {
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
            modifier = Modifier.size(24.dp)
        )
        Icon(
            painter = painterResource(id = R.drawable.ic_bell_filled),
            contentDescription = "Notificaciones",
            modifier = Modifier.size(24.dp)
        )

        // SOS Button
        Box(
            modifier = Modifier
                .size(56.dp)
                .clip(CircleShape)
                .background(MaterialTheme.colorScheme.background),
            contentAlignment = Alignment.Center
        ) {
            Text("SOS", fontWeight = FontWeight.Bold)
        }

        Icon(
            painter = painterResource(id = R.drawable.ic_book_filled),
            contentDescription = "Guía",
            modifier = Modifier.size(24.dp)
        )
        Icon(
            painter = painterResource(id = R.drawable.ic_person_circle_filled),
            contentDescription = "Perfil",
            modifier = Modifier.size(24.dp)
        )
    }
}

@Composable
fun GuiaSintomasPage() {
    Column(
        modifier = Modifier
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        TitleSection("Síntomas en la Anafilaxia")

        CardSection(
            "1. Piel", R.drawable.guias_piel, listOf(
                "Ronchas rojas que pican.",
                "Hinchazón y/o picor en palmas de las manos.",
                "Hinchazón y/o picor en plantas de los pies."
            )
        )

        CardSection(
            "2. Respiratorio", R.drawable.guias_respiratorio, listOf(
                "Tos.",
                "Sensación de algo atorado en la garganta.",
                "Silbidos en el pecho.",
                "Falta de aire."
            )
        )

        CardSection(
            "3. Cardiovascular", R.drawable.guias_cardiovascular, listOf(
                "Palpitaciones.",
                "Mareo.",
                "Baja presión.",
                "Desmayo."
            )
        )

        CardSection(
            "4. Digestivo", R.drawable.guias_digestivo, listOf(
                "Náuseas.",
                "Vómito.",
                "Diarrea.",
                "Sabor metálico en la boca."
            )
        )
    }
}

@Composable
fun GuiaQueHacerPage() {
    Column(
        modifier = Modifier
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        TitleSection("¿Qué hacer cuando se presenta una anafilaxia?")

        CardSection(
            "1. Reconocer la anafilaxia", R.drawable.guias_anafilexia, listOf(
                "Reacción alérgica grave de presentación rápida y potencialmente mortal.",
                "Entre 50–112 episodios por cada 100,000 personas/año.",
                "Mortalidad estimada entre 0.05% y 2%.",
                "(Consulta la guía de síntomas para reconocerla)."
            )
        )

        CardSection(
            "2. Retirado del alérgeno", R.drawable.guias_retirado, listOf(
                "Suspender fármacos sospechosos.",
                "Retirar aguijón tras picadura de abeja (prima la rapidez).",
                "No provocar vómito; retirar restos de alimento en la boca.",
                "Retirar productos de látex si se sospecha alergia."
            )
        )

        CardSection(
            "3. Aplicar la Adrenalina RÁPIDAMENTE", R.drawable.guias_aplicacion, listOf(
                "Preparar el autoinyector/jeringa con la dosis correcta.",
                "Sitio: cara anterolateral del muslo, a medio camino entre cadera y rodilla.",
                "Inyección intramuscular con ángulo de 90°.",
                "Retirar aguja y masajear suavemente la zona."
            )
        )
    }
}


@Composable
fun TitleSection(title: String) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Image(
            painter = painterResource(id = R.drawable.ic_book_filled),
            contentDescription = "Libro",
            modifier = Modifier.size(24.dp)
        )
        Spacer(Modifier.width(6.dp))
        Text(
            text = title,
            fontWeight = FontWeight.SemiBold,
            fontSize = 18.sp
        )
    }
}

@Composable
fun CardSection(title: String, imageRes: Int, bullets: List<String>) {
    Card(
        shape = RoundedCornerShape(12.dp),
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(6.dp)
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(
                    text = title,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp
                )
                Image(
                    painter = painterResource(id = imageRes),
                    contentDescription = "Imagen de la tarjeta",
                    modifier = Modifier
                        .size(60.dp)
                        .clip(RoundedCornerShape(10.dp))
                )
            }

            Spacer(Modifier.height(8.dp))

            bullets.forEach {
                Row(verticalAlignment = Alignment.Top) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_info_circle),
                        contentDescription = "Bullet",
                        modifier = Modifier
                            .size(10.dp)
                            .padding(top = 6.dp)
                    )
                    Spacer(Modifier.width(6.dp))
                    Text(text = it)
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GuiasScreenPreview() {
    CmicaTheme {
        GuiasScreen()
    }
}