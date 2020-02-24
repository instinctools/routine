import {Alert, Button, FlatList, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import Swipeable from 'react-native-swipeable-row';
import {style} from '../styles/TodoListStyle';
import moment from "moment";
import {connect} from "react-redux";
import Action from '../action/todos';

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
        const items = this.state ? adjustTime(this.state.items) : [];
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

const adjustTime = (todos) => {
    let currentTime = moment().startOf("day");
    return todos.map((item) => {
        let todoTime = moment(item.timestamp);
        let diffDays = todoTime.diff(currentTime, `d`);
        let targetDate = undefined;
        if (diffDays === 0) {
            targetDate = "Today"
        } else if (diffDays === 1) {
            targetDate = "Tomorrow"
        } else if (diffDays === 7) {
            targetDate = "1 week left"
        } else if (diffDays > 1 && diffDays < 7) {
            targetDate = `${diffDays} days left`
        } else if (diffDays === -1) {
            targetDate = "Yesterday"
        } else if (diffDays < -1) {
            targetDate = todoTime.fromNow();
        }
        let period = undefined;
        if (item.period === "1") {
            if (item.periodUnit === Action.Period.DAY) {
                period = "Every day"
            } else if (item.periodUnit === Action.Period.WEEK) {
                period = "Once a week"
            } else if (item.periodUnit === Action.Period.MONTH) {
                period = "Once a month"
            }
        } else {
            period = `Every ${item.period} ${item.periodUnit.toLowerCase()}s`
        }
        // console.log(`adjustTime: todoTime=${todoTime.format("YYYY-MM-DD")}; when=${targetDate}; diffDays=${diffDays}`);
        return {
            ...item,
            diff: diffDays,
            targetDate,
            periodStr: period
        };
    }).slice().sort((value1, value2) => {
        return value1.diff - value2.diff
    });
};
