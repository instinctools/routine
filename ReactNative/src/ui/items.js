import {Alert, Button, FlatList, Text, TouchableOpacity, View, TouchableHighlight} from 'react-native';
import React from 'react';
import Swipeable from 'react-native-swipeable-row';
import {todoListStyle, toolbarStyle} from '../styles/Styles';
import moment from "moment";
import {connect} from "react-redux";
import Action from '../action/todos';
import {calculateTargetDate, pickColorBetween, prettyPeriod} from "../utils";
import Icon from 'react-native-vector-icons/Ionicons';
import {TouchableRipple} from 'react-native-paper';

const ITEM_TYPE_TODO = `ITEM_TYPE_TODO`;
const ITEM_TYPE_SEPARATOR = `ITEM_TYPE_SEPARATOR`;
const SEPARATOR_ID = -1;

export class TodoList extends React.Component {

    static navigationOptions = ({navigation}) => {
        return {
            title: 'Routine',
            headerTitleStyle: toolbarStyle.title,
            headerRight: () => (
                <TouchableRipple style={toolbarStyle.menuItem}
                                 borderless={true}
                                 onPress={navigation.getParam('navigateToDetails')}>
                    <Icon name="md-add" size={24}/>
                </TouchableRipple>
            )
        }
    };

    constructor(props, context) {
        super(props, context);
        this.state = {
            items: [],
            swipeable: {
                id: undefined,
                isMenuActivated: false
            }
        }
    }

    componentDidMount() {
        this.props.navigation.setParams({
            navigateToDetails: () => (this.props.navigation.navigate(`Details`))
        });
    }

    render() {
        console.log(`TodoList render state: ${JSON.stringify(this.state)}`);
        console.log(`TodoList render props: ${JSON.stringify(this.props)}`);
        const items = this.state ? toUiModels(this.state.items) : [];
        return (
            <FlatList contentContainerStyle={todoListStyle.container}
                      scrollEnabled={!(this.state.swipeable.id)}
                      data={items}
                      keyExtractor={item => item.id}
                      renderItem={({item}) => createItemView(item, this)}
            />
        );
    }

    static getDerivedStateFromProps(props, state) {
        return {
            ...state,
            items: props.items,
            swipeable: props.swipeable
        };
    }
}

const createItemView = (item, component) => {
    if (item.itemType === ITEM_TYPE_SEPARATOR) {
        return <View style={todoListStyle.itemExpiredSeparator}/>
    } else {
        const isMenuActivated = component.state.swipeable.id === item.id && component.state.swipeable.isMenuActivated;
        return <Swipeable
            onLeftActionActivate={() => (component.props.changeMenuActivationState(true))}
            onLeftActionDeactivate={() => (component.props.changeMenuActivationState(false))}
            onRightActionActivate={() => (component.props.changeMenuActivationState(true))}
            onRightActionDeactivate={() => (component.props.changeMenuActivationState(false))}

            onSwipeStart={() => (component.props.changeSwipeableState(item.id))}
            onSwipeRelease={() => (component.props.changeSwipeableState(undefined))}

            leftContent={createSwipeableContent(`Reset`, `flex-end`, isMenuActivated)}
            rightContent={createSwipeableContent(`Delete`, `flex-start`, isMenuActivated)}
            onLeftActionRelease={() => component.props.resetTodo(item.id)}
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
                            onPress: () => component.props.deleteTodo(item.id)
                        },
                    ]
                )}
        >
            <TouchableRipple
                style={{...todoListStyle.item, backgroundColor: item.backgroundColor}}
                borderless={true}
                onPress={() => {
                    component.props.navigation.navigate("Details", {id: item.id})
                }}>
                <View>
                    <View style={todoListStyle.itemHeader}>
                        <Text style={todoListStyle.itemHeaderText}>{item.title}</Text>
                    </View>
                    <View style={todoListStyle.itemFooter}>
                        <Text style={todoListStyle.itemFooterText}>{item.periodStr}</Text>
                        <Text style={todoListStyle.itemFooterText}>{item.targetDate}</Text>
                    </View>
                </View>
            </TouchableRipple>
        </Swipeable>
    }
};

const createSwipeableContent = (text, alignItems, isMenuActivated) => {
    let color;
    if (isMenuActivated) {
        color = `#b2b2b2`;
    } else {
        color = '#E3E3E3';
    }

    return <View style={{flex: 1, alignItems: alignItems}}>
        <View style={{
            ...todoListStyle.itemSwipeContent,
            backgroundColor: color,
        }}>
            <Text style={todoListStyle.itemSwipeText}>
                {text}
            </Text>
        </View>
    </View>;
};

export default connect(
    previousState => {
        return {
            items: previousState.todos.items,
            swipeable: previousState.swipeable
        };
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
            if (uiTodos.length > 0) {
                uiTodos.push({
                    id: SEPARATOR_ID,
                    itemType: ITEM_TYPE_SEPARATOR
                });
            }
            lastExpiredTodoFound = true
        }
        uiTodos.push({
            ...item,
            targetDate: calculateTargetDate(todoTime),
            periodStr: prettyPeriod(item.period, item.periodUnit),
            backgroundColor: pickColorBetween(i),
            itemType: ITEM_TYPE_TODO
        })
    }
    return uiTodos;
};
