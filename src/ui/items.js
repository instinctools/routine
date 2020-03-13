import {Alert, Button, FlatList, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import Swipeable from 'react-native-swipeable-row';
import {style} from '../styles/TodoListStyle';
import moment from "moment";
import {connect} from "react-redux";
import Action from '../action/todos';
import {calculateTargetDate, pickColorBetween, prettyPeriod} from "../utils";

export class TodoList extends React.Component {

    constructor(props, context) {
        super(props, context);
        this.state = {items: []}
    }

    render() {
        console.log(`TodoList render state: ${JSON.stringify(this.state)}`);
        console.log(`TodoList render props: ${JSON.stringify(this.props)}`);
        const swipeLeftContent = (
            <View style={{
                flex: 1,
                backgroundColor: 'blue',
                justifyContent: 'flex-end',
                flexDirection: "row"
            }}>
                <View style={{
                    padding: 8,
                    backgroundColor: 'green',
                    alignSelf: 'center'
                }}>
                    <Text>Reset</Text>
                </View>
            </View>
        );
        const swipeRightContent = (
            <View style={{
                flex: 1,
                backgroundColor: 'blue',
                justifyContent: 'flex-start',
                flexDirection: "row"
            }}>
                <View style={{
                    padding: 8,
                    backgroundColor: 'red',
                    alignSelf: 'center'
                }}>
                    <Text>Delete</Text>
                </View>
            </View>
        );
        const items = this.state ? toUiModels(this.state.items) : [];
        return (
            <View style={{position: "relative"}}>
                <Button title="Add task"
                        onPress={() =>
                            this.props.navigation.navigate("Details")
                        }/>
                <FlatList style={style.container}
                          data={items}
                          keyExtractor={item => item.id}
                          renderItem={({item}) =>
                              <Swipeable
                                  leftContent={swipeLeftContent}
                                  rightContent={swipeRightContent}
                                  onLeftActionRelease={() => this.props.resetTodo(item.id)}
                                  onRightActionRelease={() =>
                                      Alert.alert(
                                          '',
                                          "Are you sure want to delete this task?",
                                          [
                                              {
                                                  text: 'Cancel',
                                                  style: 'cancel',
                                              },
                                              {
                                                  text: 'Delete',
                                                  onPress: () => this.props.deleteTodo(item.id)
                                              },
                                          ]
                                      )}
                              >
                                  <TouchableOpacity
                                      onPress={() => {
                                          this.props.navigation.navigate("Details", {id: item.id})
                                      }}>
                                      <View style={{...style.item, backgroundColor: item.backgroundColor}}>
                                          <View style={style.itemHeader}>
                                              <Text style={style.itemHeaderText}>{item.title}</Text>
                                          </View>
                                          <View style={style.itemFooter}>
                                              <Text style={style.itemFooterText}>{item.periodStr}</Text>
                                              <Text style={style.itemFooterText}>{item.targetDate}</Text>
                                          </View>
                                      </View>
                                  </TouchableOpacity>
                              </Swipeable>
                          }
                />
            </View>

        );
    }

    static getDerivedStateFromProps(props, state) {
        return {...state, items: props.items};
    }
}

export default connect(
    previousState => {
        const {todos} = previousState;
        return {...todos};
    },
    Action
)(TodoList);

const toUiModels = (todos) => {
    const currentTime = moment().startOf("day");
    const uiTodos = [];
    for (let i = 0; i < todos.length; i++) {
        const item = todos[i];
        let todoTime = moment(item.timestamp);
        uiTodos.push({
            title: item.title,
            diff: todoTime.diff(currentTime, `d`),
            targetDate: calculateTargetDate(todoTime),
            periodStr: prettyPeriod(item.period, item.periodUnit),
            backgroundColor: pickColorBetween(i)
        })
    }
    return uiTodos.slice().sort((value1, value2) => {
        return value1.diff - value2.diff
    });
};
