import * as React from 'react';
import {createStackNavigator} from 'react-navigation-stack';
import {CreateTodo} from './src/ui/CreateTodo';
import {TodoList} from './src/ui/TodoList';
import {createAppContainer} from 'react-navigation';

const AppNavigator = createStackNavigator(
    {
        CreateTodo: CreateTodo,
        TodoList: TodoList,
    },
    {
        initialRouteName: TodoList.name,
    },
);

export default createAppContainer(AppNavigator);
