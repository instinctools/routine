import {Button, FlatList, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {style} from '../styles/TodoListStyle';
import {CreateTodo} from '../ui/CreateTodo';
import {store} from "../data/Store";
import {resetTodo} from "../data/Action";
import moment from "moment";

export class TodoList extends React.Component {

    componentDidMount() {
        this.unsubscribe = store.subscribe(() => this.forceUpdate())
    }

    componentWillUnmount() {
        this.unsubscribe()
    }

    render() {
        console.log(`render state: ${JSON.stringify(store.getState())}`);
        const todos = adjustTime(store.getState().todos);
        return (
            <View style={{position: "relative"}}>
                <Button title="Add task"
                        onPress={() =>
                            this.props.navigation.navigate(CreateTodo.name)
                        }/>
                <FlatList style={style.container}
                          data={todos}
                          keyExtractor={item => item.id}
                          renderItem={({item}) =>
                              <TouchableOpacity
                                  onPress={() => {
                                      resetTodo(item.id)
                                  }}>
                                  <View style={style.item}>
                                      <Text style={style.itemTitle}>{item.title}</Text>
                                      <Text>{item.timestamp}</Text>
                                  </View>
                              </TouchableOpacity>
                          }
                />
            </View>

        );
    }
}

const adjustTime = (todos) => {
    let currentTime = moment();
    return todos.map((item) => {
        let todoTime = moment(item.timestamp);
        let diffTime = todoTime.diff(currentTime, `d`);
        return Object.assign({}, item, {
            timestamp: diffTime
        })
    }).slice().sort((value1, value2) => {
        return value1.timestamp - value2.timestamp
    });
};
