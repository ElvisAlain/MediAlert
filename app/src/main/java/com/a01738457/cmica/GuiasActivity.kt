package com.a01738457.cmica

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.withStyle
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
                    color = MaterialTheme.colorScheme.surfaceVariant
                ) {
                    GuiasScreen()
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GuiasScreen() {
    var showCMICAInfo by remember { mutableStateOf(false) }
    var isEnglish by remember { mutableStateOf(false) }

    Scaffold(
        bottomBar = { BottomTabBar() }
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
                    painter = painterResource(id = R.drawable.ic_book_filled),
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(Modifier.width(6.dp))
                Text(
                    text = if (isEnglish) "Guide" else "Guía",
                    fontSize = 20.sp,
                    fontWeight = FontWeight.SemiBold
                )
                Spacer(Modifier.weight(1f))
                Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_bell_filled),
                        contentDescription = "Notificaciones",
                        modifier = Modifier.size(24.dp)
                    )
                    LanguageDropdown(
                        isEnglish = isEnglish,
                        onLanguageChange = { newValue -> isEnglish = newValue }
                    )
                }
            }

            Column(
                modifier = Modifier
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Button(
                    onClick = {
                        showCMICAInfo = true
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF2196F3).copy(alpha = 0.1f),
                        contentColor = Color(0xFF2196F3)
                    ),
                    shape = RoundedCornerShape(50),
                    modifier = Modifier
                        .padding(top = 4.dp)
                        .height(40.dp),
                    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp)
                ) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_info_circle),
                        contentDescription = null,
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(Modifier.width(8.dp))
                    Text(
                        text = if (isEnglish) "About Us (CMICA)" else "Conócenos (CMICA)",
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 14.sp
                    )
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_book_filled),
                        contentDescription = null,
                        tint = Color(0xFFFF9800),
                        modifier = Modifier.size(24.dp)
                    )
                    Spacer(Modifier.width(8.dp))
                    Text(
                        text = if (isEnglish) "General Anaphylaxis Information" else "Información General de Anafilaxia",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold
                    )
                }

                InfoCard(
                    title = if (isEnglish) "1. What is Anaphylaxis?" else "1. ¿Qué es la Anafilaxia?",
                    imageRes = R.drawable.guias_anafilexia,
                    bullets = listOf(
                        if (isEnglish) "It is a severe allergic reaction of rapid onset and can be fatal." else "Es una reacción alérgica grave de presentación rápida y puede ser mortal.",
                        if (isEnglish) "It is estimated that between 50 and 112 episodes occur per 100,000 people per year." else "Se estima que ocurren entre 50 y 112 episodios por cada 100,000 personas por año.",
                        if (isEnglish) "Among these cases, mortality has been between 0.05% and 2%." else "Entre estos casos, la mortalidad se ha situado entre el 0,05 y el 2 %."
                    )
                )

                InfoCard(
                    title = if (isEnglish) "2. Most frequent causes" else "2. Causas más frecuentes",
                    iconRes = R.drawable.ic_exclamation_triangle,
                    bullets = listOf(
                        if (isEnglish) "Food." else "Alimentos.",
                        if (isEnglish) "Drugs (Medication)." else "Fármacos.",
                        if (isEnglish) "Latex." else "Látex.",
                        if (isEnglish) "Hymenoptera insect stings (bees, wasps)." else "Picaduras de insectos himenópteros (abejas, avispas)."
                    )
                )

                SignsAndSymptomsCard(isEnglish = isEnglish)

                InfoCard(
                    title = if (isEnglish) "4. What to do if I suffer anaphylaxis?" else "4. ¿Qué hacer si sufro anafilaxia?",
                    iconRes = R.drawable.ic_person_running,
                    bullets = listOf(
                        if (isEnglish) "In AnafilApp you will find graphic information on how to act." else "En AnafilApp encontrarás la información gráfica para saber cómo actuar.",
                        if (isEnglish) "Notify school/work environment about your diagnosis so they know how to help." else "Se debe avisar en el ámbito laboral y/o escolar acerca de su diagnóstico para que sepan cómo actuar.",
                        if (isEnglish) "The affected person must go to an EMERGENCY service immediately." else "La persona afectada debe acudir a un servicio de URGENCIAS inmediatamente.",
                        if (isEnglish) "If possible, request a BASAL SERUM TRYPTASE test to confirm diagnosis." else "Si es posible, solicitar prueba de TRIPTASA SÉRICA BASAL para confirmar diagnóstico."
                    )
                )

                InfoCard(
                    title = if (isEnglish) "5. Allergen Withdrawal" else "5. Retirada del Alérgeno",
                    imageRes = R.drawable.guias_retirado,
                    bullets = listOf(
                        if (isEnglish) "Suspend suspected drugs." else "Suspender fármacos sospechosos.",
                        if (isEnglish) "Remove bee sting quickly (speed prevails over form)." else "Retirar aguijón de abeja rápidamente (prima la rapidez sobre la forma).",
                        if (isEnglish) "Do not induce vomiting for food, but remove food debris from mouth." else "No provocar vómito en alimentos, pero sí retirar restos de la boca.",
                        if (isEnglish) "Remove latex products (gloves, probes) if allergy is suspected." else "Retirar productos de látex (guantes, sondas) si hay sospecha de alergia."
                    )
                )

                InfoCard(
                    title = if (isEnglish) "6. Apply Adrenaline" else "6. Aplicar Adrenalina",
                    imageRes = R.drawable.guias_aplicacion,
                    bullets = listOf(
                        if (isEnglish) "Intramuscular adrenaline is the ONLY treatment of choice." else "La adrenalina intramuscular es el ÚNICO tratamiento de elección.",
                        if (isEnglish) "It must be administered QUICKLY." else "Se debe administrar RÁPIDAMENTE.",
                        if (isEnglish) "Every person at risk should carry adrenaline." else "Toda persona con riesgo debería llevar consigo adrenalina.",
                        if (isEnglish) "Apply following medical instructions for intramuscular injection." else "Aplicar siguiendo las instrucciones médicas para inyección intramuscular."
                    )
                )

                PreventionCard(isEnglish = isEnglish)

                Spacer(Modifier.height(16.dp))
            }
        }
    }

    if (showCMICAInfo) {
        CMICAInfoDialog(
            isEnglish = isEnglish,
            onDismiss = { showCMICAInfo = false }
        )
    }
}

@Composable
fun LanguageDropdown(
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
                text = {
                    Text("Español")
                },
                onClick = {
                    onLanguageChange(false)
                    expanded = false
                }
            )
            DropdownMenuItem(
                text = {
                    Text("English")
                },
                onClick = {
                    onLanguageChange(true)
                    expanded = false
                }
            )
        }
    }
}

@Composable
fun InfoCard(
    title: String,
    imageRes: Int? = null,
    iconRes: Int? = null,
    bullets: List<String>
) {
    Card(
        shape = RoundedCornerShape(12.dp),
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(6.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        )
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Text(
                    text = title,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.weight(1f)
                )

                Spacer(Modifier.width(12.dp))

                if (imageRes != null) {
                    Image(
                        painter = painterResource(id = imageRes),
                        contentDescription = null,
                        modifier = Modifier
                            .size(60.dp)
                            .clip(RoundedCornerShape(10.dp))
                    )
                } else if (iconRes != null) {
                    Box(
                        modifier = Modifier
                            .size(60.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.1f)),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            painter = painterResource(id = iconRes),
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.primary.copy(alpha = 0.6f),
                            modifier = Modifier.size(30.dp)
                        )
                    }
                }
            }

            Spacer(Modifier.height(8.dp))

            bullets.forEach { bullet ->
                Row(
                    modifier = Modifier.padding(vertical = 4.dp),
                    horizontalArrangement = Arrangement.Start
                ) {
                    Text(
                        text = "•",
                        fontSize = 16.sp,
                        color = Color.Gray,
                        modifier = Modifier.padding(end = 8.dp)
                    )
                    Text(
                        text = bullet,
                        fontSize = 14.sp,
                        color = Color.Gray,
                        lineHeight = 20.sp
                    )
                }
            }
        }
    }
}

@Composable
fun SignsAndSymptomsCard(isEnglish: Boolean) {
    Card(
        shape = RoundedCornerShape(12.dp),
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(6.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        )
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Text(
                    text = if (isEnglish) "3. Signs and Symptoms" else "3. Signos y Síntomas",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.weight(1f)
                )

                Spacer(Modifier.width(12.dp))

                Box(
                    modifier = Modifier
                        .size(60.dp)
                        .clip(RoundedCornerShape(10.dp))
                        .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.1f)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_cross_case),
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary.copy(alpha = 0.6f),
                        modifier = Modifier.size(30.dp)
                    )
                }
            }

            Spacer(Modifier.height(8.dp))

            SymptomCategory(
                category = if (isEnglish) "Skin:" else "Piel:",
                description = if (isEnglish) " Red itchy hives, swelling and/or itching in palms of hands, soles of feet." else " Ronchas rojas que pican, hinchazón y/o picor en palmas de las manos, plantas de los pies."
            )

            Divider(modifier = Modifier.padding(vertical = 4.dp))

            SymptomCategory(
                category = if (isEnglish) "Respiratory:" else "Respiratorio:",
                description = if (isEnglish) " Cough, sensation of something stuck in the throat, wheezing and shortness of breath." else " Tos, sensación de algo atorado en la garganta, silbido y falta de aire."
            )

            Divider(modifier = Modifier.padding(vertical = 4.dp))

            SymptomCategory(
                category = if (isEnglish) "Cardiovascular:" else "Cardiovascular:",
                description = if (isEnglish) " Palpitations, dizziness, low blood pressure and fainting." else " Palpitaciones, mareo, baja de presión y desmayo."
            )

            Divider(modifier = Modifier.padding(vertical = 4.dp))

            SymptomCategory(
                category = if (isEnglish) "Digestive:" else "Digestivo:",
                description = if (isEnglish) " Nausea, vomiting, diarrhea." else " Náusea, vómito, diarrea."
            )
        }
    }
}

@Composable
fun SymptomCategory(category: String, description: String) {
    Text(
        text = buildAnnotatedString {
            withStyle(style = SpanStyle(fontWeight = FontWeight.Bold, color = Color.Black)) {
                append(category)
            }
            withStyle(style = SpanStyle(color = Color.Gray)) {
                append(description)
            }
        },
        fontSize = 14.sp,
        lineHeight = 20.sp
    )
}

@Composable
fun PreventionCard(isEnglish: Boolean) {
    Card(
        shape = RoundedCornerShape(12.dp),
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(6.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        )
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Text(
                    text = if (isEnglish) "7. Can it be prevented?" else "7. ¿Se puede prevenir?",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.weight(1f)
                )

                Spacer(Modifier.width(12.dp))

                Box(
                    modifier = Modifier
                        .size(60.dp)
                        .clip(RoundedCornerShape(10.dp))
                        .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.1f)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_shield_filled),
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary.copy(alpha = 0.6f),
                        modifier = Modifier.size(30.dp)
                    )
                }
            }

            Spacer(Modifier.height(8.dp))

            Text(
                text = if (isEnglish) "There is no diet or preventive study for the first event. To prevent recurrence:" else "No existe dieta o estudio preventivo para el primer evento. Para prevenir que suceda nuevamente:",
                fontSize = 14.sp,
                color = Color.Gray,
                lineHeight = 20.sp,
                modifier = Modifier.padding(bottom = 8.dp)
            )

            val bullets = listOf(
                if (isEnglish) "Attend assessment by Allergology." else "Acudir a valoración por Alergología.",
                if (isEnglish) "Perform relevant allergological studies indicated by the specialist." else "Hacer los estudios alergológicos pertinentes indicados por el especialista.",
                if (isEnglish) "Have IM Adrenaline and instructions for use in a new event." else "Contar con Adrenalina IM e instrucciones para usarla en nuevo evento.",
                if (isEnglish) "Notify family, school and work environment." else "Avisar a familiares, ámbito escolar y laboral.",
                if (isEnglish) "Strictly avoid the responsible allergen." else "Evitar el alérgeno responsable."
            )

            bullets.forEach { bullet ->
                Row(
                    modifier = Modifier.padding(vertical = 4.dp),
                    horizontalArrangement = Arrangement.Start
                ) {
                    Text(
                        text = "•",
                        fontSize = 16.sp,
                        color = Color.Gray,
                        modifier = Modifier.padding(end = 8.dp)
                    )
                    Text(
                        text = bullet,
                        fontSize = 14.sp,
                        color = Color.Gray,
                        lineHeight = 20.sp
                    )
                }
            }
        }
    }
}

@Composable
fun CMICAInfoDialog(isEnglish: Boolean, onDismiss: () -> Unit) {
    AlertDialog(
        onDismissRequest = onDismiss,
        containerColor = MaterialTheme.colorScheme.surface,
        shape = RoundedCornerShape(20.dp),
        confirmButton = {
            TextButton(
                onClick = onDismiss,
                colors = ButtonDefaults.textButtonColors(
                    contentColor = Color(0xFF2196F3)
                )
            ) {
                Text("OK", fontWeight = FontWeight.SemiBold)
            }
        },
        title = {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.fillMaxWidth()
            ) {
                Image(
                    painter = painterResource(id = R.drawable.cmica_logo),
                    contentDescription = "CMICA Logo",
                    modifier = Modifier
                        .height(80.dp)
                        .padding(vertical = 12.dp)
                )
                Text(
                    text = "CMICA",
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.Black
                )
                Spacer(Modifier.height(8.dp))
                Text(
                    text = if (isEnglish)
                        "Mexican College of Clinical Immunology and Allergy A.C."
                    else
                        "Colegio Mexicano de Inmunología Clínica y Alergia A.C.",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    textAlign = TextAlign.Center,
                    color = Color.Gray,
                    modifier = Modifier.padding(horizontal = 8.dp)
                )
            }
        },
        text = {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .verticalScroll(rememberScrollState()),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.Start,
                    verticalAlignment = Alignment.Top
                ) {
                    Text(
                        text = "•",
                        fontSize = 16.sp,
                        color = Color.Gray,
                        modifier = Modifier.padding(end = 8.dp, top = 2.dp)
                    )
                    Text(
                        text = if (isEnglish)
                            "Founded in 1946, it is the body that groups all Medical Specialists in Allergy and Immunology in the country."
                        else
                            "Fue fundado en 1946 y es el organismo que agrupa a todos los Médicos Especialistas en Alergia e Inmunología del país.",
                        fontSize = 14.sp,
                        color = Color.Gray,
                        lineHeight = 20.sp,
                        modifier = Modifier.weight(1f)
                    )
                }
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.Start,
                    verticalAlignment = Alignment.Top
                ) {
                    Text(
                        text = "•",
                        fontSize = 16.sp,
                        color = Color.Gray,
                        modifier = Modifier.padding(end = 8.dp, top = 2.dp)
                    )
                    Text(
                        text = if (isEnglish)
                            "Its main function is to promote academic growth and continuing medical education for its members through the organization of update courses, national and international congresses, symposiums, and workshops."
                        else
                            "Su principal función es promover el crecimiento académico y la educación médica continua de sus miembros mediante la organización de cursos de actualización, congresos nacionales e internacionales, simposios y talleres.",
                        fontSize = 14.sp,
                        color = Color.Gray,
                        lineHeight = 20.sp,
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }
    )
}

@Composable
fun BottomTabBar() {
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
                    context.startActivity(
                        Intent(context, MainActivity::class.java)
                    )
                }
        )
        Icon(
            painter = painterResource(id = R.drawable.ic_bell_filled),
            contentDescription = "Notificaciones",
            modifier = Modifier
                .size(24.dp)
                .clickable {
                    context.startActivity(
                        Intent(context, NotificacionesActivity::class.java)
                    )
                }
        )

        Box(
            modifier = Modifier
                .size(56.dp)
                .clip(CircleShape)
                .background(Color(0xFFFF5252))
                .clickable {
                    // TODO: Implementar funcionalidad SOS
                },
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
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(24.dp)
            // Esta es la pantalla actual, no necesita navegación
        )
        Icon(
            painter = painterResource(id = R.drawable.ic_person_circle_filled),
            contentDescription = "Perfil",
            modifier = Modifier
                .size(24.dp)
                .clickable {
                    context.startActivity(
                        Intent(context, DatosPersonalesActivity::class.java)
                    )
                }
        )
    }
}

@Preview(showBackground = true)
@Composable
fun GuiasScreenPreview() {
    CmicaTheme {
        GuiasScreen()
    }
}