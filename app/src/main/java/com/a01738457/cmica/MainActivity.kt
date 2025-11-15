package com.a01738457.cmica

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.a01738457.cmica.ui.theme.CmicaTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CmicaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = Color.White
                ) {
                    RegistrationScreen()
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RegistrationScreen() {
    val context = LocalContext.current

    var nombre by remember { mutableStateOf("") }
    var apellidos by remember { mutableStateOf("") }
    var telefono by remember { mutableStateOf("") }
    var contactoEmergencia by remember { mutableStateOf("") }
    var idiomaSeleccionado by remember { mutableStateOf("") }
    var isAdultConfirmed by remember { mutableStateOf(false) }
    var showLanguageMenu by remember { mutableStateOf(false) }

    var nombreError by remember { mutableStateOf<String?>(null) }
    var apellidosError by remember { mutableStateOf<String?>(null) }
    var telefonoError by remember { mutableStateOf<String?>(null) }
    var contactoError by remember { mutableStateOf<String?>(null) }
    var ageError by remember { mutableStateOf<String?>(null) }

    val isEnglish = idiomaSeleccionado == "English"

    fun clearErrors() {
        nombreError = null
        apellidosError = null
        telefonoError = null
        contactoError = null
        ageError = null
    }

    fun validateForm(): Boolean {
        clearErrors()

        if (nombre.trim().isEmpty()) {
            nombreError = if (isEnglish) "Name is missing." else "Falta el nombre."
            return false
        }
        if (apellidos.trim().isEmpty()) {
            apellidosError = if (isEnglish) "Last name is missing." else "Faltan los apellidos."
            return false
        }
        if (telefono.length != 10 || !telefono.all { it.isDigit() }) {
            telefonoError = if (isEnglish) "Phone number must have 10 valid digits." else "El teléfono propio debe tener 10 dígitos válidos."
            return false
        }
        if (contactoEmergencia.length != 10 || !contactoEmergencia.all { it.isDigit() }) {
            contactoError = if (isEnglish) "Emergency contact must have 10 valid digits." else "El contacto de emergencia debe tener 10 dígitos válidos."
            return false
        }
        if (!isAdultConfirmed) {
            ageError = if (isEnglish) "You must confirm this field to continue." else "Debes confirmar este campo para continuar."
            return false
        }
        return true
    }

    // Función para guardar y navegar
    fun saveAndNavigate() {
        // TODO: Guardar datos en base de datos/SharedPreferences
        // TODO: Navegar a la siguiente pantalla (HomeActivity o DatosPersonalesActivity)
        context.startActivity(Intent(context, DatosPersonalesActivity::class.java))
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Image(
            painter = painterResource(id = R.drawable.anafilapp_logo),
            contentDescription = "AnafilApp Logo",
            modifier = Modifier
                .height(180.dp)
                .fillMaxWidth()
        )

        Image(
            painter = painterResource(id = R.drawable.cmica_logo),
            contentDescription = "CMICA Logo",
            modifier = Modifier
                .width(200.dp)
                .height(50.dp)
                .padding(top = 8.dp)
        )

        Spacer(modifier = Modifier.height(16.dp))

        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center,
            modifier = Modifier.padding(top = 16.dp)
        ) {
            Icon(
                painter = painterResource(id = R.drawable.ic_registro_filled),
                contentDescription = "Registro Icon",
                modifier = Modifier.size(24.dp),
                tint = Color.Black
            )
            Spacer(modifier = Modifier.width(6.dp))
            Text(
                text = if (isEnglish) "Registration" else "Registro",
                fontSize = 20.sp,
                fontWeight = FontWeight.SemiBold,
                color = Color.Black
            )
        }

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = if (isEnglish) "Enter requested data:" else "Ingresa los datos solicitados:",
            fontSize = 14.sp,
            color = Color.Gray
        )

        Spacer(modifier = Modifier.height(16.dp))

        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Column {
                OutlinedTextField(
                    value = nombre,
                    onValueChange = { nombre = it },
                    label = { Text(if (isEnglish) "Name(s)" else "Nombre(s)") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(6.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        unfocusedContainerColor = Color.Transparent,
                        focusedContainerColor = Color.Transparent,
                        unfocusedBorderColor = Color.Gray.copy(alpha = 0.2f),
                        focusedBorderColor = Color.Gray.copy(alpha = 0.2f)
                    ),
                    isError = nombreError != null
                )
                nombreError?.let {
                    Text(
                        text = it,
                        color = Color.Red,
                        fontSize = 12.sp,
                        modifier = Modifier.padding(start = 4.dp, top = 4.dp)
                    )
                }
            }

            Column {
                OutlinedTextField(
                    value = apellidos,
                    onValueChange = { apellidos = it },
                    label = { Text(if (isEnglish) "Last Name" else "Apellidos") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(6.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        unfocusedContainerColor = Color.Transparent,
                        focusedContainerColor = Color.Transparent,
                        unfocusedBorderColor = Color.Gray.copy(alpha = 0.2f),
                        focusedBorderColor = Color.Gray.copy(alpha = 0.2f)
                    ),
                    isError = apellidosError != null
                )
                apellidosError?.let {
                    Text(
                        text = it,
                        color = Color.Red,
                        fontSize = 12.sp,
                        modifier = Modifier.padding(start = 4.dp, top = 4.dp)
                    )
                }
            }

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 6.dp)
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(56.dp)
                        .border(1.dp, Color.Gray.copy(alpha = 0.2f), RoundedCornerShape(6.dp))
                        .clickable { showLanguageMenu = true },
                    contentAlignment = Alignment.CenterStart
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = if (idiomaSeleccionado.isEmpty()) {
                                if (isEnglish) "Select Language" else "Selecciona idioma"
                            } else {
                                idiomaSeleccionado
                            },
                            color = if (idiomaSeleccionado.isEmpty()) Color.Gray.copy(alpha = 0.6f) else Color.Black,
                            fontSize = 16.sp
                        )
                        Icon(
                            imageVector = Icons.Default.KeyboardArrowDown,
                            contentDescription = "Dropdown Arrow",
                            tint = Color.Gray.copy(alpha = 0.6f),
                            modifier = Modifier.padding(end = 8.dp)
                        )
                    }
                }

                DropdownMenu(
                    expanded = showLanguageMenu,
                    onDismissRequest = { showLanguageMenu = false },
                    modifier = Modifier
                        .background(Color.White)
                        .width(IntrinsicSize.Max)
                ) {
                    DropdownMenuItem(
                        text = { Text("Español") },
                        onClick = {
                            idiomaSeleccionado = "Español"
                            showLanguageMenu = false
                        }
                    )
                    DropdownMenuItem(
                        text = { Text("English") },
                        onClick = {
                            idiomaSeleccionado = "English"
                            showLanguageMenu = false
                        }
                    )
                }
            }

            Column {
                OutlinedTextField(
                    value = telefono,
                    onValueChange = { if (it.length <= 10) telefono = it },
                    label = { Text(if (isEnglish) "Phone (10 digits)" else "Teléfono (10 dígitos)") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(6.dp),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    colors = OutlinedTextFieldDefaults.colors(
                        unfocusedContainerColor = Color.Transparent,
                        focusedContainerColor = Color.Transparent,
                        unfocusedBorderColor = Color.Gray.copy(alpha = 0.2f),
                        focusedBorderColor = Color.Gray.copy(alpha = 0.2f)
                    ),
                    isError = telefonoError != null
                )
                telefonoError?.let {
                    Text(
                        text = it,
                        color = Color.Red,
                        fontSize = 12.sp,
                        modifier = Modifier.padding(start = 4.dp, top = 4.dp)
                    )
                }
            }

            Column {
                OutlinedTextField(
                    value = contactoEmergencia,
                    onValueChange = { if (it.length <= 10) contactoEmergencia = it },
                    label = { Text(if (isEnglish) "Emergency Contact (Phone)" else "Contacto de emergencia (Teléfono)") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(6.dp),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    colors = OutlinedTextFieldDefaults.colors(
                        unfocusedContainerColor = Color.Transparent,
                        focusedContainerColor = Color.Transparent,
                        unfocusedBorderColor = Color.Gray.copy(alpha = 0.2f),
                        focusedBorderColor = Color.Gray.copy(alpha = 0.2f)
                    ),
                    isError = contactoError != null
                )
                contactoError?.let {
                    Text(
                        text = it,
                        color = Color.Red,
                        fontSize = 12.sp,
                        modifier = Modifier.padding(start = 4.dp, top = 4.dp)
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        Column(
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { isAdultConfirmed = !isAdultConfirmed },
                verticalAlignment = Alignment.Top
            ) {
                Icon(
                    painter = painterResource(
                        id = if (isAdultConfirmed) R.drawable.ic_checkmark_square_filled else R.drawable.ic_shield_filled
                    ),
                    contentDescription = "Checkbox",
                    tint = if (isAdultConfirmed) Color(0xFF2196F3) else Color.Gray,
                    modifier = Modifier
                        .size(24.dp)
                        .padding(top = 2.dp)
                )
                Spacer(modifier = Modifier.width(10.dp))
                Text(
                    text = if (isEnglish)
                        "I am of legal age or use the application under the supervision of a guardian."
                    else
                        "Soy mayor de edad o utilizo la aplicación bajo la supervisión de un tutor.",
                    fontSize = 13.sp,
                    color = Color.Black,
                    lineHeight = 18.sp
                )
            }
            ageError?.let {
                Text(
                    text = it,
                    color = Color.Red,
                    fontSize = 12.sp,
                    modifier = Modifier.padding(start = 34.dp, top = 4.dp)
                )
            }
        }

        Spacer(modifier = Modifier.height(10.dp))

        Button(
            onClick = {
                if (validateForm()) {
                    saveAndNavigate()
                }
            },
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            colors = ButtonDefaults.buttonColors(
                containerColor = if (isAdultConfirmed) Color(0xFF2196F3) else Color.Gray
            ),
            shape = RoundedCornerShape(8.dp)
        ) {
            Text(
                text = if (isEnglish) "Create Account" else "Crear Cuenta",
                color = Color.White,
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium
            )
        }

        Spacer(modifier = Modifier.height(24.dp))
    }
}

@Preview(showBackground = true)
@Composable
fun RegistrationScreenPreview() {
    CmicaTheme {
        RegistrationScreen()
    }
}