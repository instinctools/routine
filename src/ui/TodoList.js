import {FlatList, Text, View} from 'react-native';
import React from 'react';
import { style } from '../styles/TodoListStyle';


const createTodos = (count) => {
    let todos = [];
    for (let i = 0; i < count; i++) {
        todos.push({
            title: `TODO ${i}`,
            timestamp: 333422323
        })
    }
    return todos
};

export class TodoList extends React.Component {

    render() {
        return (
            <FlatList style = {style.container}
                data={createTodos(200)}
                renderItem={({item}) =>
                    <View style = {style.item}>
                        <Text style = {style.itemTitle}>{item.title}</Text>
                        <Text>{item.timestamp}</Text>
                    </View>
                }
            />
        );
    }
}
