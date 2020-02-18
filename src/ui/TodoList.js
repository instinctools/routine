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
        console.log(`render state: ${JSON.stringify(store.getState())}`);
        return (
            <View style={{position: "relative"}}>
                <Button title="Add task"
                        onPress={() =>
                            this.props.navigation.navigate(CreateTodo.name)
                        }/>
                <FlatList style={style.container}
                          data={store.getState().todos}
                          keyExtractor={item => item.id}
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
