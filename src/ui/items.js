import {Alert, Button, FlatList, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import Swipeable from 'react-native-swipeable-row';
import {style} from '../styles/TodoListStyle';
import moment from "moment";
import {connect} from "react-redux";
import Action from '../action/todos';
import {calculateTargetDate, prettyPeriod} from "../utils";

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
                    backgroundColor: 'red',
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
                    backgroundColor: 'red',
                    alignSelf: 'center'
                }}>
                    <Text>Reset</Text>
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
                                  onRightActionRelease={() => this.props.resetTodo(item.id)}
                              >
                                  <TouchableOpacity
                                      onPress={() => {
                                          this.props.navigation.navigate("Details", {id: item.id})
                                      }}
                                      onLongPress={() =>
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
                                          )
                                      }
                                  >
                                      <View style={{...style.item, backgroundColor: 'lightgray'}}>
                                          <View style={style.itemHeader}>
                                              <Text>{item.title}</Text>
                                          </View>
                                          <View style={style.itemFooter}>
                                              <Text>{item.periodStr}</Text>
                                              <Text>{item.targetDate}</Text>
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
    let currentTime = moment().startOf("day");
    return todos.map((item) => {
        let todoTime = moment(item.timestamp);
        return {
            ...item,
            diff: todoTime.diff(currentTime, `d`),
            targetDate: calculateTargetDate(todoTime),
            periodStr: prettyPeriod(item.period, item.periodUnit)
        };
    }).slice().sort((value1, value2) => {
        return value1.diff - value2.diff
    });
};
