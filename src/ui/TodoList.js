import {Button, FlatList, Text, View} from 'react-native';
import React from 'react';
import {style} from '../styles/TodoListStyle';
import {CreateTodo} from '../ui/CreateTodo';
import {store} from "../data/Store";

export class TodoList extends React.Component {

    componentDidMount() {
        this.unsubscribe = store.subscribe(() => this.forceUpdate())
    }

    componentWillUnmount() {
        this.unsubscribe()
    }

    render() {
        const state = store.getState();
        return (
            <View style={{position: "relative"}}>
                <Button title="Add task"
                        onPress={() =>
                            this.props.navigation.navigate(CreateTodo.name)
                        }/>
                <FlatList style={style.container}
                          data={state}
                          renderItem={({item}) =>
                              <View style={style.item}>
                                  <Text style={style.itemTitle}>{item.title}</Text>
                                  <Text>{item.timestamp}</Text>
                              </View>
                          }
                />
            </View>

        );
    }
}
