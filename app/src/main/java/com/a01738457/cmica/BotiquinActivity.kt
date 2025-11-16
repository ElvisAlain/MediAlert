package com.a01738457.cmica

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.*
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
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import com.a01738457.cmica.ui.theme.CmicaTheme
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*

class BotiquinActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            CmicaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.surfaceVariant
                ) {
                    BotiquinScreen()
                }
            }
        }
    }
}

// Clase de datos para Receta
data class RecetaMedica(
    val id: String = UUID.randomUUID().toString(),
    val fechaSubida: Date,
    val imagenUri: Uri?
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BotiquinScreen() {
    val context = LocalContext.current
    val coroutineScope = rememberCoroutineScope()

    // Estados
    var isEnglish by remember { mutableStateOf(false) }
    var userName by remember { mutableStateOf("Camila") }

    // Estados para nueva receta
    var newRecetaDate by remember { mutableStateOf(Calendar.getInstance()) }
    var newRecetaImageUri by remember { mutableStateOf<Uri?>(null) }
    var showDatePicker by remember { mutableStateOf(false) }
    var error by remember { mutableStateOf<String?>(null) }

    // Estados para confirmaciones
    var showSaveConfirmation by remember { mutableStateOf(false) }
    var showDeleteConfirmation by remember { mutableStateOf(false) }
    var recetaParaBorrar by remember { mutableStateOf<RecetaMedica?>(null) }

    // Lista de recetas guardadas
    var recetas by remember { mutableStateOf(listOf<RecetaMedica>()) }

    // Launcher para galería
    val galleryLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        newRecetaImageUri = uri
        error = null
    }

    // Función para guardar receta
    fun saveReceta() {
        error = null

        if (newRecetaImageUri == null) {
            error = if (isEnglish)
                "Please upload an image of the prescription."
            else
                "Por favor, sube una imagen de la receta."
            return
        }

        val newReceta = RecetaMedica(
            fechaSubida = newRecetaDate.time,
            imagenUri = newRecetaImageUri
        )

        recetas = recetas + newReceta

        // Limpiar campos
        newRecetaDate = Calendar.getInstance()
        newRecetaImageUri = null

        // Mostrar confirmación
        showSaveConfirmation = true
        coroutineScope.launch {
            delay(2000)
            showSaveConfirmation = false
        }
    }

    // Función para borrar receta con deshacer
    fun deleteReceta(receta: RecetaMedica) {
        showSaveConfirmation = false
        recetaParaBorrar = receta
        recetas = recetas.filter { it.id != receta.id }
        showDeleteConfirmation = true

        // Timer de 3 segundos para borrar definitivamente
        coroutineScope.launch {
            delay(3000)
            if (recetaParaBorrar?.id == receta.id) {
                recetaParaBorrar = null
                showDeleteConfirmation = false
            }
        }
    }

    // Función para deshacer borrado
    fun undoDelete() {
        recetaParaBorrar?.let { receta ->
            recetas = recetas + receta
        }
        recetaParaBorrar = null
        showDeleteConfirmation = false
    }

    // Recetas ordenadas por fecha
    val sortedRecetas = recetas.sortedByDescending { it.fechaSubida }

    Scaffold(
        bottomBar = { BottomTabBarBotiquin() }
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.surfaceVariant)
        ) {
            Column(modifier = Modifier.fillMaxSize()) {
                // Header
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_cross_case),
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSurface,
                        modifier = Modifier.size(24.dp)
                    )
                    Spacer(Modifier.width(6.dp))
                    Text(
                        text = if (isEnglish) "First Aid Kit of $userName" else "Botiquín de $userName",
                        fontSize = 20.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                    Spacer(Modifier.weight(1f))
                    Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_bell_filled),
                            contentDescription = "Notificaciones",
                            modifier = Modifier
                                .size(24.dp)
                                .clickable {
                                    context.startActivity(Intent(context, NotificacionesActivity::class.java))
                                }
                        )
                        LanguageDropdownBotiquin(
                            isEnglish = isEnglish,
                            onLanguageChange = { isEnglish = it }
                        )
                    }
                }

                // Contenido principal
                Column(
                    modifier = Modifier
                        .weight(1f)
                        .verticalScroll(rememberScrollState())
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                    verticalArrangement = Arrangement.spacedBy(20.dp)
                ) {
                    // Card: Agregar Receta Médica
                    BotiquinCard {
                        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                            Text(
                                text = if (isEnglish) "Add Medical Prescription" else "Agregar Receta Médica",
                                fontSize = 16.sp,
                                fontWeight = FontWeight.SemiBold
                            )

                            // Botón para subir imagen
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(if (newRecetaImageUri != null) 100.dp else 50.dp)
                                    .background(Color(0xFFF2F2F7), RoundedCornerShape(10.dp))
                                    .clickable { galleryLauncher.launch("image/*") }
                                    .padding(12.dp),
                                contentAlignment = if (newRecetaImageUri != null) Alignment.Center else Alignment.CenterStart
                            ) {
                                if (newRecetaImageUri != null) {
                                    AsyncImage(
                                        model = newRecetaImageUri,
                                        contentDescription = "Receta",
                                        modifier = Modifier
                                            .fillMaxSize()
                                            .clip(RoundedCornerShape(8.dp)),
                                        contentScale = ContentScale.Crop
                                    )
                                } else {
                                    Row(
                                        modifier = Modifier.fillMaxWidth(),
                                        horizontalArrangement = Arrangement.SpaceBetween,
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Text(
                                            text = if (isEnglish) "Upload Prescription" else "Subir Receta",
                                            color = Color.Gray
                                        )
                                        Icon(
                                            painter = painterResource(id = R.drawable.ic_upload),
                                            contentDescription = "Upload",
                                            tint = Color.Gray,
                                            modifier = Modifier.size(24.dp)
                                        )
                                    }
                                }
                            }

                            // Selector de fecha
                            DateSelectorBotiquin(
                                label = if (isEnglish) "Date" else "Fecha",
                                date = newRecetaDate,
                                onClick = { showDatePicker = true }
                            )

                            // Mostrar error si hay
                            error?.let {
                                Text(
                                    text = it,
                                    color = Color.Red,
                                    fontSize = 12.sp
                                )
                            }

                            // Botón Agregar
                            Button(
                                onClick = { saveReceta() },
                                modifier = Modifier.fillMaxWidth(),
                                colors = ButtonDefaults.buttonColors(
                                    containerColor = Color(0xFF2196F3)
                                )
                            ) {
                                Text(
                                    text = if (isEnglish) "Add" else "Agregar",
                                    fontSize = 16.sp
                                )
                            }
                        }
                    }

                    // Card: Mis Recetas Guardadas
                    BotiquinCard {
                        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                            Text(
                                text = if (isEnglish) "My Saved Prescriptions" else "Mis Recetas Guardadas",
                                fontSize = 16.sp,
                                fontWeight = FontWeight.SemiBold
                            )

                            if (sortedRecetas.isNotEmpty()) {
                                sortedRecetas.forEach { receta ->
                                    RecetaCardView(
                                        receta = receta,
                                        isEnglish = isEnglish,
                                        onDelete = { deleteReceta(receta) }
                                    )
                                }
                            } else {
                                Text(
                                    text = if (isEnglish)
                                        "You don't have saved prescriptions yet."
                                    else
                                        "Aún no tienes Recetas guardadas.",
                                    color = Color.Gray,
                                    fontSize = 14.sp,
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(vertical = 16.dp),
                                    textAlign = androidx.compose.ui.text.style.TextAlign.Center
                                )
                            }
                        }
                    }
                }

                // Alertas (Toasts)
                Column(
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 4.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    // Confirmación de guardado
                    AnimatedVisibility(
                        visible = showSaveConfirmation,
                        enter = fadeIn() + slideInVertically(initialOffsetY = { it }),
                        exit = fadeOut() + slideOutVertically(targetOffsetY = { it })
                    ) {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(
                                    Color(0xFF4CAF50).copy(alpha = 0.2f),
                                    RoundedCornerShape(8.dp)
                                )
                                .padding(12.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = if (isEnglish)
                                    "Prescription saved successfully!"
                                else
                                    "¡Receta guardada con éxito!",
                                color = Color(0xFF4CAF50),
                                fontWeight = FontWeight.SemiBold,
                                fontSize = 13.sp
                            )
                        }
                    }

                    // Confirmación de borrado con deshacer
                    AnimatedVisibility(
                        visible = showDeleteConfirmation,
                        enter = fadeIn() + slideInVertically(initialOffsetY = { -it }),
                        exit = fadeOut() + slideOutVertically(targetOffsetY = { -it })
                    ) {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(
                                    Color(0xFFF44336).copy(alpha = 0.1f),
                                    RoundedCornerShape(8.dp)
                                )
                                .padding(12.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(
                                    text = if (isEnglish)
                                        "Prescription deleted."
                                    else
                                        "Receta eliminada.",
                                    color = Color(0xFFF44336),
                                    fontWeight = FontWeight.SemiBold,
                                    fontSize = 13.sp
                                )
                                TextButton(onClick = { undoDelete() }) {
                                    Text(
                                        text = if (isEnglish) "Undo" else "Deshacer",
                                        color = Color(0xFFF44336),
                                        fontWeight = FontWeight.Bold,
                                        fontSize = 13.sp
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Date Picker Dialog
    if (showDatePicker) {
        val datePickerState = rememberDatePickerState(
            initialSelectedDateMillis = newRecetaDate.timeInMillis
        )

        DatePickerDialog(
            onDismissRequest = { showDatePicker = false },
            confirmButton = {
                TextButton(onClick = {
                    datePickerState.selectedDateMillis?.let {
                        newRecetaDate.timeInMillis = it
                    }
                    showDatePicker = false
                }) {
                    Text("OK")
                }
            },
            dismissButton = {
                TextButton(onClick = { showDatePicker = false }) {
                    Text(if (isEnglish) "Cancel" else "Cancelar")
                }
            }
        ) {
            DatePicker(state = datePickerState)
        }
    }
}

@Composable
fun RecetaCardView(
    receta: RecetaMedica,
    isEnglish: Boolean,
    onDelete: () -> Unit
) {
    val dateFormat = SimpleDateFormat("dd 'de' MMMM 'de' yyyy", Locale("es"))

    Box {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(Color(0xFFF2F2F7), RoundedCornerShape(10.dp))
                .padding(start = 12.dp, end = 12.dp, bottom = 12.dp, top = 40.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            // Fecha
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = if (isEnglish) "Date Uploaded: " else "Fecha Subida: ",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium
                )
                Text(
                    text = dateFormat.format(receta.fechaSubida),
                    fontSize = 14.sp,
                    color = Color.Gray
                )
            }

            // Imagen
            if (receta.imagenUri != null) {
                AsyncImage(
                    model = receta.imagenUri,
                    contentDescription = "Receta",
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(250.dp)
                        .clip(RoundedCornerShape(8.dp)),
                    contentScale = ContentScale.Fit
                )
            }
        }

        // Botón de borrar
        IconButton(
            onClick = onDelete,
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(8.dp)
                .size(32.dp)
                .background(Color.White, CircleShape)
        ) {
            Icon(
                painter = painterResource(id = R.drawable.ic_trash_circle_filled),
                contentDescription = "Delete",
                tint = Color(0xFFF44336),
                modifier = Modifier.size(28.dp)
            )
        }
    }
}

@Composable
fun DateSelectorBotiquin(
    label: String,
    date: Calendar,
    onClick: () -> Unit
) {
    val dateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())

    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        Text(label, fontSize = 14.sp)
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(Color(0xFFF2F2F7), RoundedCornerShape(10.dp))
                .clickable { onClick() }
                .padding(12.dp)
        ) {
            Text(
                text = dateFormat.format(date.time),
                fontSize = 16.sp
            )
        }
    }
}

@Composable
fun BotiquinCard(content: @Composable ColumnScope.() -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(
                elevation = 6.dp,
                shape = RoundedCornerShape(12.dp),
                clip = false
            )
            .background(Color.White, RoundedCornerShape(12.dp))
            .padding(16.dp),
        content = content
    )
}

@Composable
fun LanguageDropdownBotiquin(
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
fun BottomTabBarBotiquin() {
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
            modifier = Modifier
                .size(24.dp)
                .clickable {
                    context.startActivity(Intent(context, NotificacionesActivity::class.java))
                }
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

@Preview(showBackground = true)
@Composable
fun BotiquinScreenPreview() {
    CmicaTheme {
        BotiquinScreen()
    }
}