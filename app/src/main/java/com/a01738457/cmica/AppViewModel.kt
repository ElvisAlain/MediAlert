package com.a01738457.cmica

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class AppViewModel(application: Application) : AndroidViewModel(application) {
    private val database = AppDatabase.getDatabase(application)
    private val userDao = database.userDao()
    private val historialDao = database.historialDao()
    private val recetaDao = database.recetaDao()

    // CURRENT USER
    val currentUser: StateFlow<User?> = userDao.getCurrentUser()
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), null)

    // NOTIFICACIONES
    val notificaciones: StateFlow<List<HistorialAcciones>> = currentUser
        .flatMapLatest { user ->
            if (user != null) {
                historialDao.getHistorialByUser(user.id)
            } else {
                flowOf(emptyList())
            }
        }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val contadorNoLeidas: StateFlow<Int> = currentUser
        .flatMapLatest { user ->
            if (user != null) {
                historialDao.getContadorNoLeidas(user.id)
            } else {
                flowOf(0)
            }
        }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), 0)

    // RECETAS
    val recetas: StateFlow<List<RecetaMedica>> = currentUser
        .flatMapLatest { user ->
            if (user != null) {
                recetaDao.getRecetasByUser(user.id)
            } else {
                flowOf(emptyList())
            }
        }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    // IDIOMA
    val isEnglish: StateFlow<Boolean> = currentUser
        .map { user -> user?.idiomaSeleccionado == "English" }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), false)

    // ==================== FUNCIONES ====================

    fun insertUser(user: User) {
        viewModelScope.launch {
            userDao.insertUser(user)
        }
    }

    fun updateUser(user: User) {
        viewModelScope.launch {
            userDao.updateUser(user)
        }
    }

    fun insertAccion(tipoAccion: TipoAccion, detalle: String) {
        viewModelScope.launch {
            val user = currentUser.value
            if (user != null) {
                val accion = HistorialAcciones(
                    tipo_accion = tipoAccion.value,
                    detalle = detalle,
                    userId = user.id
                )
                historialDao.insertAccion(accion)
            }
        }
    }

    fun marcarNotificacionesComoLeidas() {
        viewModelScope.launch {
            val user = currentUser.value
            if (user != null) {
                historialDao.marcarTodasComoLeidas(user.id)
            }
        }
    }

    fun insertReceta(imagenUri: String, fechaSubida: Long = System.currentTimeMillis()) {
        viewModelScope.launch {
            val user = currentUser.value
            if (user != null) {
                val receta = RecetaMedica(
                    imagenUri = imagenUri,
                    fechaSubida = fechaSubida,
                    userId = user.id
                )
                recetaDao.insertReceta(receta)
            }
        }
    }

    fun deleteReceta(receta: RecetaMedica) {
        viewModelScope.launch {
            recetaDao.deleteReceta(receta)
        }
    }

    suspend fun isFirstLaunch(): Boolean {
        return userDao.getUserCount() == 0
    }
}