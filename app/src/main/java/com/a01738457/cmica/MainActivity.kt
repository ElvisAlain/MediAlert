package com.a01738457.cmica

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
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

@Composable
fun RegistrationScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 24.dp, vertical = 32.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Logo
        Image(
            painter = painterResource(id = R.drawable.cmica_logo),
            contentDescription = "CMICA Logo",
            modifier = Modifier
                .size(width = 200.dp, height = 80.dp)
                .padding(top = 40.dp)
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Título
        Text(
            text = "MediAlert",
            fontSize = 24.sp,
            fontWeight = FontWeight.SemiBold,
            color = Color(0xFF0D47A1)
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Subtítulo Registro
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            Image(
                painter = painterResource(id = R.drawable.ic_registro_filled),
                contentDescription = "Registro Icon",
                modifier = Modifier.size(24.dp)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Text(
                text = "Registro",
                fontSize = 24.sp,
                fontWeight = FontWeight.SemiBold,
                color = Color.Black
            )
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Instrucciones
        Text(
            text = "Ingresa los datos solicitados:",
            fontSize = 14.sp,
            color = Color.Gray
        )

        Spacer(modifier = Modifier.height(20.dp))

        // Campos de texto
        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            // Nombre(s)
            OutlinedTextField(
                value = "",
                onValueChange = {},
                label = { Text("Nombre(s)") },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    unfocusedContainerColor = Color.Transparent,
                    focusedContainerColor = Color.Transparent,
                    unfocusedBorderColor = Color.Gray.copy(alpha = 0.3f),
                    focusedBorderColor = Color.Gray.copy(alpha = 0.3f)
                )
            )

            // Apellidos
            OutlinedTextField(
                value = "",
                onValueChange = {},
                label = { Text("Apellidos") },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    unfocusedContainerColor = Color.Transparent,
                    focusedContainerColor = Color.Transparent,
                    unfocusedBorderColor = Color.Gray.copy(alpha = 0.3f),
                    focusedBorderColor = Color.Gray.copy(alpha = 0.3f)
                )
            )

            // Selecciona idioma (Menu)
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp)
                    .border(1.dp, Color.Gray.copy(alpha = 0.3f), RoundedCornerShape(8.dp))
                    .clickable {},
                contentAlignment = Alignment.CenterStart
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Selecciona idioma",
                        color = Color.Gray
                    )
                    Icon(
                        imageVector = Icons.Default.KeyboardArrowDown,
                        contentDescription = "Dropdown Arrow",
                        tint = Color.Gray
                    )
                }
            }

            // Teléfono
            OutlinedTextField(
                value = "",
                onValueChange = {},
                label = { Text("Teléfono") },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    unfocusedContainerColor = Color.Transparent,
                    focusedContainerColor = Color.Transparent,
                    unfocusedBorderColor = Color.Gray.copy(alpha = 0.3f),
                    focusedBorderColor = Color.Gray.copy(alpha = 0.3f)
                )
            )

            // Contacto de emergencia
            OutlinedTextField(
                value = "",
                onValueChange = {},
                label = { Text("Contacto de emergencia (Teléfono)") },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    unfocusedContainerColor = Color.Transparent,
                    focusedContainerColor = Color.Transparent,
                    unfocusedBorderColor = Color.Gray.copy(alpha = 0.3f),
                    focusedBorderColor = Color.Gray.copy(alpha = 0.3f)
                )
            )
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Botón "Crear Cuenta"
        Button(
            onClick = { /* TODO: Navegar a la siguiente pantalla */ },
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF0D47A1)),
            shape = RoundedCornerShape(8.dp)
        ) {
            Text(
                text = "Crear Cuenta",
                color = Color.White,
                fontSize = 18.sp
            )
        }

        Spacer(modifier = Modifier.weight(1f))
    }
}

@Preview(showBackground = true)
@Composable
fun RegistrationScreenPreview() {
    CmicaTheme {
        RegistrationScreen()
    }
}