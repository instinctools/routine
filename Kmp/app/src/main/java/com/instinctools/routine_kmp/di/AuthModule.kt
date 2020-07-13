package com.instinctools.routine_kmp.di

import com.instinctools.routine_kmp.data.auth.AuthRepository
import com.instinctools.routine_kmp.data.auth.FirebaseAuthenticator
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

@Module
object AuthModule {

    @Provides @Singleton
    fun provideFirebaseAuthenticator() = FirebaseAuthenticator()

    @Provides @Singleton
    fun provideAuthRepository(
        firebaseAuthenticator: FirebaseAuthenticator
    ) = AuthRepository(firebaseAuthenticator)
}