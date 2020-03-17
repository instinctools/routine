import {Alert, Button, FlatList, Text, TouchableOpacity, View, TouchableHighlight} from 'react-native';
import React from 'react';
import Swipeable from 'react-native-swipeable-row';
import {todoListStyle, toolbarStyle} from '../styles/Styles';
import moment from "moment";
import {connect} from "react-redux";
import Action from '../action/todos';
import {calculateTargetDate, pickColorBetween, prettyPeriod} from "../utils";
import Icon from 'react-native-vector-icons/Ionicons';

export class TodoList extends React.Component {

    static navigationOptions = ({navigation}) => {
        return {
            title: 'Routine',
            headerTitleStyle: toolbarStyle.title,
            headerRight: () => (
                <TouchableOpacity style={toolbarStyle.menuIcon}
                    onPress={navigation.getParam('navigateToDetails')}>
                    <Icon name="md-add" size={24}/>
                </TouchableOpacity>
            )
        }
    };

    constructor(props, context) {
        super(props, context);
        this.state = {items: []}
    }

    componentDidMount() {
        this.props.navigation.setParams({
            navigateToDetails: () => (this.props.navigation.navigate(`Details`))
        });
    }

    render() {
        console.log(`TodoList render state: ${JSON.stringify(this.state)}`);
        console.log(`TodoList render props: ${JSON.stringify(this.props)}`);
        const swipeLeftContent = (
            <View style={{ flex: 1, alignItems: 'flex-end'}}>
                <Text style={todoListStyle.itemSwipeContent}>
                    Reset
                </Text>
            </View>
        );
        const swipeRightContent = (
            <View style={{ flex: 1}}>
                <Text style={todoListStyle.itemSwipeContent}>
                    Delete
                </Text>
            </View>
        );
        const items = this.state ? toUiModels(this.state.items) : [];
        return (
            <View style={{position: "relative"}}>
                <FlatList style={todoListStyle.container}
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
                                      <View style={{...todoListStyle.item, backgroundColor: item.backgroundColor}}>
                                          <View style={todoListStyle.itemHeader}>
                                              <Text style={todoListStyle.itemHeaderText}>{item.title}</Text>
                                          </View>
                                          <View style={todoListStyle.itemFooter}>
                                              <Text style={todoListStyle.itemFooterText}>{item.periodStr}</Text>
                                              <Text style={todoListStyle.itemFooterText}>{item.targetDate}</Text>
                                          </View>
                                      </View>
                                      {createSeparator(item.isLastExpired)}
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

const createSeparator = (isLastExpired) => {
    if (isLastExpired) {
        return <View style={todoListStyle.itemExpiredSeparator}/>
    } else {
        return undefined
    }
};

export default connect(
    previousState => {
        const {todos} = previousState;
        return {...todos};
    },
    Action
)(TodoList);

const toUiModels = (todos) => {
    const currentTime = moment().startOf("day");
    const sortTodos = todos.slice().sort((value1, value2) => {
        return moment(value1.timestamp).diff(currentTime, `d`) - moment(value2.timestamp).diff(currentTime, `d`)
    });
    const uiTodos = [];
    let lastExpiredTodoFound = false;
    for (let i = 0; i < sortTodos.length; i++) {
        const item = sortTodos[i];
        let todoTime = moment(item.timestamp);
        if (!lastExpiredTodoFound && !todoTime.isBefore(currentTime)) {
            const lastExpiredTodo = uiTodos[i - 1];
            if (lastExpiredTodo !== undefined) {
                lastExpiredTodo.isLastExpired = true
            }
            lastExpiredTodoFound = true
        }
        uiTodos.push({
            id: item.id,
            title: item.title,
            targetDate: calculateTargetDate(todoTime),
            periodStr: prettyPeriod(item.period, item.periodUnit),
            backgroundColor: pickColorBetween(i)
        })
    }
    return uiTodos;
};
