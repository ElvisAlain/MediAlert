package com.a01738457.cmica

import androidx.room.*
import kotlinx.coroutines.flow.Flow
import java.util.*

// ==================== ENTITIES ====================

@Entity(tableName = "users")
data class User(
    @PrimaryKey val id: String = UUID.randomUUID().toString(),
    val nombre: String,
    val apellidos: String,
    val idiomaSeleccionado: String = "Español",
    val telefono: String,
    val contactoEmergencia: String,
    val direccion: String = "No especificada",
    val sexo: String = "No especificado",
    val peso: Double = 0.0,
    val fechaNacimiento: Long = System.currentTimeMillis(),
    val tipoSangre: String = "N/A",
    val diagnostico: String = "N/A",
    val alergias: String = "No especificada",
    val profileImageUri: String? = null,
    val fechaCreacion: Long = System.currentTimeMillis()
)

@Entity(
    tableName = "historial_acciones",
    foreignKeys = [ForeignKey(
        entity = User::class,
        parentColumns = ["id"],
        childColumns = ["userId"],
        onDelete = ForeignKey.CASCADE
    )],
    indices = [Index("userId")]
)
data class HistorialAcciones(
    @PrimaryKey val id: String = UUID.randomUUID().toString(),
    val tipo_accion: String,
    val fecha_hora: Long = System.currentTimeMillis(),
    val detalle: String,
    var leida: Boolean = false,
    val userId: String
)

@Entity(
    tableName = "recetas_medicas",
    foreignKeys = [ForeignKey(
        entity = User::class,
        parentColumns = ["id"],
        childColumns = ["userId"],
        onDelete = ForeignKey.CASCADE
    )],
    indices = [Index("userId")]
)
data class RecetaMedica(
    @PrimaryKey val id: String = UUID.randomUUID().toString(),
    val fechaSubida: Long = System.currentTimeMillis(),
    val imagenUri: String,
    val userId: String
)

enum class TipoAccion(val value: String) {
    SOS_CALL("SOS_CALL"),
    PROFILE_UPDATE("PROFILE_UPDATE")
}

// ==================== DAOs ====================

@Dao
interface UserDao {
    @Query("SELECT * FROM users ORDER BY fechaCreacion DESC LIMIT 1")
    fun getCurrentUser(): Flow<User?>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertUser(user: User)

    @Update
    suspend fun updateUser(user: User)

    @Query("SELECT COUNT(*) FROM users")
    suspend fun getUserCount(): Int
}

@Dao
interface HistorialDao {
    @Query("SELECT * FROM historial_acciones WHERE userId = :userId ORDER BY fecha_hora DESC")
    fun getHistorialByUser(userId: String): Flow<List<HistorialAcciones>>

    @Query("SELECT COUNT(*) FROM historial_acciones WHERE userId = :userId AND leida = 0")
    fun getContadorNoLeidas(userId: String): Flow<Int>

    @Insert
    suspend fun insertAccion(accion: HistorialAcciones)

    @Query("UPDATE historial_acciones SET leida = 1 WHERE userId = :userId")
    suspend fun marcarTodasComoLeidas(userId: String)
}

@Dao
interface RecetaDao {
    @Query("SELECT * FROM recetas_medicas WHERE userId = :userId ORDER BY fechaSubida DESC")
    fun getRecetasByUser(userId: String): Flow<List<RecetaMedica>>

    @Insert
    suspend fun insertReceta(receta: RecetaMedica)

    @Delete
    suspend fun deleteReceta(receta: RecetaMedica)
}