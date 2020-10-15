package com.routine.vm

import com.routine.test_utils.CommonRule
import org.junit.Before
import org.junit.Rule

class AndroidAppViewModelTest {

    @get:Rule
    var commonRule = CommonRule()

    private lateinit var androidAppViewModel: AndroidAppViewModel

    @Before
    fun init(){
        androidAppViewModel = AndroidAppViewModel(commonRule.todosRepository)
    }


}
