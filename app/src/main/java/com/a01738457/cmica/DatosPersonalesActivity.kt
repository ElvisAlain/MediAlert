package com.a01738457.cmica

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.*
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
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
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import com.a01738457.cmica.ui.theme.CmicaTheme
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*

class DatosPersonalesActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CmicaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.surfaceVariant
                ) {
                    DatosPersonalesScreen()
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DatosPersonalesScreen() {
    val context = LocalContext.current

    var isEditing by remember { mutableStateOf(false) }
    var showSaveConfirmation by remember { mutableStateOf(false) }
    var isEnglish by remember { mutableStateOf(false) }

    var nombre by remember { mutableStateOf("Camila") }
    var apellidos by remember { mutableStateOf("Juárez") }
    var telefono by remember { mutableStateOf("2354687958") }
    var contactoEmergencia by remember { mutableStateOf("2368545879") }
    var direccion by remember { mutableStateOf("Avenida José María") }
    var sexo by remember { mutableStateOf("Mujer") }
    var peso by remember { mutableStateOf("60.0") }
    var fechaNacimiento by remember { mutableStateOf(Calendar.getInstance()) }
    var tipoSangre by remember { mutableStateOf("O+") }
    var diagnostico by remember { mutableStateOf("Asma") }
    var alergias by remember { mutableStateOf("Polvo, polen") }
    var profileImageUri by remember { mutableStateOf<Uri?>(null) }

    var nombreError by remember { mutableStateOf<String?>(null) }
    var apellidosError by remember { mutableStateOf<String?>(null) }
    var telefonoError by remember { mutableStateOf<String?>(null) }
    var contactoError by remember { mutableStateOf<String?>(null) }
    var direccionError by remember { mutableStateOf<String?>(null) }
    var sexoError by remember { mutableStateOf<String?>(null) }
    var pesoError by remember { mutableStateOf<String?>(null) }
    var tipoSangreError by remember { mutableStateOf<String?>(null) }
    var diagnosticoError by remember { mutableStateOf<String?>(null) }
    var alergiasError by remember { mutableStateOf<String?>(null) }

    var showDatePicker by remember { mutableStateOf(false) }

    val galleryLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        profileImageUri = uri
    }

    fun clearErrors() {
        nombreError = null
        apellidosError = null
        telefonoError = null
        contactoError = null
        direccionError = null
        sexoError = null
        pesoError = null
        tipoSangreError = null
        diagnosticoError = null
        alergiasError = null
    }

    fun calculateAge(birthDate: Calendar): Int {
        val today = Calendar.getInstance()
        var age = today.get(Calendar.YEAR) - birthDate.get(Calendar.YEAR)
        if (today.get(Calendar.DAY_OF_YEAR) < birthDate.get(Calendar.DAY_OF_YEAR)) {
            age--
        }
        return age
    }

    fun validateAndSave(): Boolean {
        clearErrors()
        var isValid = true

        if (nombre.trim().isEmpty()) {
            nombreError = if (isEnglish) "Name is missing." else "Falta el nombre."
            isValid = false
        }
        if (apellidos.trim().isEmpty()) {
            apellidosError = if (isEnglish) "Last name is missing." else "Faltan los apellidos."
            isValid = false
        }
        if (telefono.length != 10 || !telefono.all { it.isDigit() }) {
            telefonoError = if (isEnglish) "Phone must have 10 valid digits." else "El teléfono propio debe tener 10 dígitos válidos."
            isValid = false
        }
        if (contactoEmergencia.length != 10 || !contactoEmergencia.all { it.isDigit() }) {
            contactoError = if (isEnglish) "Emergency contact must have 10 valid digits." else "El contacto de emergencia debe tener 10 dígitos válidos."
            isValid = false
        }
        if (direccion.trim().isEmpty()) {
            direccionError = if (isEnglish) "Address is missing." else "Falta la dirección."
            isValid = false
        }
        if (diagnostico.trim().isEmpty()) {
            diagnosticoError = if (isEnglish) "Diagnosis is missing." else "Falta el diagnóstico."
            isValid = false
        }
        if (alergias.trim().isEmpty()) {
            alergiasError = if (isEnglish) "Allergy(ies) missing." else "Falta(n) la(s) alergía(s)."
            isValid = false
        }

        val pesoValue = peso.toDoubleOrNull() ?: 0.0
        if (pesoValue <= 0.0) {
            pesoError = if (isEnglish) "Weight must be greater than 0." else "El peso debe ser mayor a 0."
            isValid = false
        }

        val sexoOptions = if (isEnglish) listOf("Unspecified", "Male", "Female", "Other") else listOf("No especificado", "Hombre", "Mujer", "Otro")
        if (sexo == sexoOptions[0]) {
            sexoError = if (isEnglish) "Select a sex." else "Selecciona un sexo."
            isValid = false
        }

        if (tipoSangre == "N/A") {
            tipoSangreError = if (isEnglish) "Select a blood type." else "Selecciona un tipo de sangre."
            isValid = false
        }

        // Validaciones de longitud
        if (nombre.length > 25) {
            nombreError = if (isEnglish) "Name must not exceed 25 characters." else "El nombre no debe exceder los 25 caracteres."
            isValid = false
        }
        if (apellidos.length > 25) {
            apellidosError = if (isEnglish) "Last name must not exceed 25 characters." else "Los apellidos no debe exceder los 25 caracteres."
            isValid = false
        }
        if (direccion.length > 40) {
            direccionError = if (isEnglish) "Address must not exceed 40 characters." else "La dirección no debe exceder los 40 caracteres."
            isValid = false
        }
        if (diagnostico.length > 40) {
            diagnosticoError = if (isEnglish) "Diagnosis must not exceed 40 characters." else "El diagnóstico no debe exceder los 40 caracteres."
            isValid = false
        }
        if (alergias.length > 40) {
            alergiasError = if (isEnglish) "Allergies must not exceed 40 characters." else "Las alergias no debe exceder los 40 caracteres."
            isValid = false
        }

        if (isValid) {
            // TODO: Guardar en base de datos
            isEditing = false
            showSaveConfirmation = true

            kotlinx.coroutines.GlobalScope.launch {
                kotlinx.coroutines.delay(2000)
                showSaveConfirmation = false
            }
        }

        return isValid
    }

    Scaffold(
        bottomBar = { BottomTabBarPersonal() }
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
                    painter = painterResource(id = R.drawable.ic_info_circle),
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(Modifier.width(6.dp))
                Text(
                    text = if (isEnglish) "Personal Data" else "Datos Personales",
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
                    LanguageDropdownPersonal(
                        isEnglish = isEnglish,
                        onLanguageChange = { isEnglish = it }
                    )
                }
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(56.dp)
                        .clip(CircleShape)
                        .background(Color.LightGray)
                        .clickable {
                            if (isEditing) {
                                galleryLauncher.launch("image/*")
                            }
                        },
                    contentAlignment = Alignment.Center
                ) {
                    if (profileImageUri != null) {
                        AsyncImage(
                            model = profileImageUri,
                            contentDescription = "Profile Image",
                            modifier = Modifier.fillMaxSize(),
                            contentScale = ContentScale.Crop
                        )
                    } else {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_person_circle_filled),
                            contentDescription = "Default Profile",
                            modifier = Modifier.size(56.dp),
                            tint = Color.Gray.copy(alpha = 0.7f)
                        )
                    }

                    if (isEditing) {
                        Box(
                            modifier = Modifier
                                .fillMaxSize()
                                .background(Color.Black.copy(alpha = 0.4f)),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.ic_camera_filled),
                                contentDescription = "Camera",
                                tint = Color.White,
                                modifier = Modifier.size(24.dp)
                            )
                        }
                    }
                }

                Spacer(Modifier.width(12.dp))

                Text(
                    text = nombre,
                    fontSize = 20.sp,
                    fontWeight = FontWeight.SemiBold
                )

                Spacer(Modifier.weight(1f))

                Button(
                    onClick = {
                        if (isEditing) {
                            validateAndSave()
                        } else {
                            isEditing = true
                        }
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF2196F3)
                    ),
                    shape = RoundedCornerShape(50),
                    contentPadding = PaddingValues(horizontal = 10.dp, vertical = 6.dp)
                ) {
                    Text(
                        text = if (isEditing) {
                            if (isEnglish) "Save" else "Guardar"
                        } else {
                            if (isEnglish) "Edit" else "Editar"
                        },
                        fontSize = 14.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                }
            }

            Column(
                modifier = Modifier
                    .weight(1f)
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                verticalArrangement = Arrangement.spacedBy(14.dp)
            ) {
                val sexOptions = if (isEnglish)
                    listOf("Unspecified", "Male", "Female", "Other")
                else
                    listOf("No especificado", "Hombre", "Mujer", "Otro")

                val bloodTypes = listOf("N/A", "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-")

                EditableChipRow(
                    titulo = if (isEnglish) "Name: " else "Nombre: ",
                    text = nombre,
                    onTextChange = { nombre = it },
                    editable = isEditing,
                    error = nombreError
                )

                EditableChipRow(
                    titulo = if (isEnglish) "Last Name: " else "Apellidos: ",
                    text = apellidos,
                    onTextChange = { apellidos = it },
                    editable = isEditing,
                    error = apellidosError
                )

                EditableChipRow(
                    titulo = if (isEnglish) "Phone: " else "Teléfono: ",
                    text = telefono,
                    onTextChange = { if (it.length <= 10) telefono = it },
                    editable = isEditing,
                    error = telefonoError,
                    keyboardType = KeyboardType.Number
                )

                EditableChipRow(
                    titulo = if (isEnglish) "Emergency Contact: " else "Contacto Emergencias: ",
                    text = contactoEmergencia,
                    onTextChange = { if (it.length <= 10) contactoEmergencia = it },
                    editable = isEditing,
                    error = contactoError,
                    keyboardType = KeyboardType.Number
                )

                EditableChipRow(
                    titulo = if (isEnglish) "Address: " else "Dirección: ",
                    text = direccion,
                    onTextChange = { direccion = it },
                    editable = isEditing,
                    error = direccionError
                )

                PickerChipRowPersonal(
                    titulo = if (isEnglish) "Sex: " else "Sexo: ",
                    selection = sexo,
                    options = sexOptions,
                    onSelectionChange = { sexo = it },
                    editable = isEditing,
                    error = sexoError
                )

                EditableChipRow(
                    titulo = if (isEnglish) "Weight (Kg): " else "Peso (Kg): ",
                    text = peso,
                    onTextChange = { peso = it },
                    editable = isEditing,
                    error = pesoError,
                    keyboardType = KeyboardType.Decimal
                )

                DateChipRowPersonal(
                    titulo = if (isEnglish) "Date of Birth: " else "Fecha de Nacimiento: ",
                    date = fechaNacimiento,
                    editable = isEditing,
                    onClick = { if (isEditing) showDatePicker = true }
                )

                val anosText = if (isEnglish) " years" else " años"
                EditableChipRow(
                    titulo = if (isEnglish) "Age: " else "Edad: ",
                    text = "${calculateAge(fechaNacimiento)}$anosText",
                    onTextChange = {},
                    editable = false
                )

                PickerChipRowPersonal(
                    titulo = if (isEnglish) "Blood Type: " else "Tipo de sangre: ",
                    selection = tipoSangre,
                    options = bloodTypes,
                    onSelectionChange = { tipoSangre = it },
                    editable = isEditing,
                    error = tipoSangreError
                )

                EditableChipRow(
                    titulo = if (isEnglish) "Diagnosis: " else "Diagnóstico: ",
                    text = diagnostico,
                    onTextChange = { diagnostico = it },
                    editable = isEditing,
                    error = diagnosticoError
                )

                EditableChipRow(
                    titulo = if (isEnglish) "Allergies: " else "Alergias: ",
                    text = alergias,
                    onTextChange = { alergias = it },
                    editable = isEditing,
                    error = alergiasError
                )
            }

            AnimatedVisibility(
                visible = showSaveConfirmation,
                enter = fadeIn() + slideInVertically(initialOffsetY = { it }),
                exit = fadeOut() + slideOutVertically(targetOffsetY = { it })
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp)
                        .background(
                            Color(0xFF4CAF50).copy(alpha = 0.2f),
                            RoundedCornerShape(8.dp)
                        )
                        .padding(12.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = if (isEnglish) "Data saved!" else "¡Datos guardados!",
                        color = Color(0xFF4CAF50),
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 13.sp
                    )
                }
            }
        }
    }

    if (showDatePicker) {
        val datePickerState = rememberDatePickerState(
            initialSelectedDateMillis = fechaNacimiento.timeInMillis
        )

        DatePickerDialog(
            onDismissRequest = { showDatePicker = false },
            confirmButton = {
                TextButton(onClick = {
                    datePickerState.selectedDateMillis?.let {
                        fechaNacimiento.timeInMillis = it
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
fun EditableChipRow(
    titulo: String,
    text: String,
    onTextChange: (String) -> Unit,
    editable: Boolean,
    error: String? = null,
    keyboardType: KeyboardType = KeyboardType.Text
) {
    Column {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .shadow(
                    elevation = 4.dp,
                    shape = RoundedCornerShape(50),
                    clip = false
                )
                .background(
                    if (editable) Color(0xFF2196F3).copy(alpha = 0.1f) else Color(0xFFE0E0E0),
                    RoundedCornerShape(50)
                )
                .padding(horizontal = 14.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = titulo,
                fontWeight = FontWeight.SemiBold,
                color = Color(0xFF2196F3).copy(alpha = 0.9f),
                fontSize = 16.sp
            )

            if (editable) {
                TextField(
                    value = text,
                    onValueChange = onTextChange,
                    modifier = Modifier.weight(1f),
                    textStyle = LocalTextStyle.current.copy(fontSize = 16.sp),
                    colors = TextFieldDefaults.colors(
                        focusedContainerColor = Color.Transparent,
                        unfocusedContainerColor = Color.Transparent,
                        disabledContainerColor = Color.Transparent,
                        focusedIndicatorColor = Color.Transparent,
                        unfocusedIndicatorColor = Color.Transparent
                    ),
                    keyboardOptions = KeyboardOptions(keyboardType = keyboardType),
                    singleLine = true
                )
            } else {
                Text(
                    text = text,
                    fontSize = 16.sp,
                    modifier = Modifier.weight(1f)
                )
            }
        }

        error?.let {
            Text(
                text = it,
                color = Color.Red,
                fontSize = 12.sp,
                modifier = Modifier.padding(start = 18.dp, top = 4.dp)
            )
        }
    }
}

@Composable
fun PickerChipRowPersonal(
    titulo: String,
    selection: String,
    options: List<String>,
    onSelectionChange: (String) -> Unit,
    editable: Boolean,
    error: String? = null
) {
    var expanded by remember { mutableStateOf(false) }

    Column {
        Box(
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .shadow(
                        elevation = 4.dp,
                        shape = RoundedCornerShape(50),
                        clip = false
                    )
                    .background(
                        if (editable) Color(0xFF2196F3).copy(alpha = 0.1f) else Color(0xFFE0E0E0),
                        RoundedCornerShape(50)
                    )
                    .clickable(enabled = editable) { expanded = true }
                    .padding(horizontal = 14.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = titulo,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF2196F3).copy(alpha = 0.9f),
                    fontSize = 16.sp
                )
                Text(
                    text = selection,
                    fontSize = 16.sp,
                    modifier = Modifier.weight(1f)
                )
                if (editable) {
                    Icon(
                        imageVector = Icons.Default.KeyboardArrowDown,
                        contentDescription = "Dropdown",
                        tint = Color.Gray
                    )
                }
            }

            DropdownMenu(
                expanded = expanded,
                onDismissRequest = { expanded = false }
            ) {
                options.forEach { option ->
                    DropdownMenuItem(
                        text = { Text(option) },
                        onClick = {
                            onSelectionChange(option)
                            expanded = false
                        }
                    )
                }
            }
        }

        error?.let {
            Text(
                text = it,
                color = Color.Red,
                fontSize = 12.sp,
                modifier = Modifier.padding(start = 18.dp, top = 4.dp)
            )
        }
    }
}

@Composable
fun DateChipRowPersonal(
    titulo: String,
    date: Calendar,
    editable: Boolean,
    onClick: () -> Unit
) {
    val dateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(
                elevation = 4.dp,
                shape = RoundedCornerShape(50),
                clip = false
            )
            .background(
                if (editable) Color(0xFF2196F3).copy(alpha = 0.1f) else Color(0xFFE0E0E0),
                RoundedCornerShape(50)
            )
            .clickable(enabled = editable) { onClick() }
            .padding(horizontal = 14.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = titulo,
            fontWeight = FontWeight.SemiBold,
            color = Color(0xFF2196F3).copy(alpha = 0.9f),
            fontSize = 16.sp
        )
        Text(
            text = dateFormat.format(date.time),
            fontSize = 16.sp,
            modifier = Modifier.weight(1f)
        )
    }
}

@Composable
fun LanguageDropdownPersonal(
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
fun BottomTabBarPersonal() {
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
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(24.dp)
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