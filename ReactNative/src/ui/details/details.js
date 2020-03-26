import {ScrollView, Text, TextInput, View} from 'react-native';
import React from 'react';
import {connect} from "react-redux";
import Action from '../../action/todos';
import {Period, PeriodsList} from "../../constants";
import {todoDetailsStyle, toolbarStyle} from "../../styles/Styles";
import {TouchableRipple} from "react-native-paper";
import PeriodSelector from "./PeriodSelector";

const initialState = {
    period: 1,
    periodUnit: Period.DAY
};

export class DetailsScreen extends React.Component {

    static navigationOptions = ({navigation}) => {
        const {params} = navigation.state;
        console.log(`navigationOptions: params=${JSON.stringify(params)}`);
        const canBeSaved = params ? params.canBeSaved : undefined;
        return {
            title: '',
            headerRight: () => {
                if (canBeSaved) {
                    return (
                        <TouchableRipple style={toolbarStyle.menuItem}
                                         borderless={true}
                                         onPress={navigation.getParam('done')}>
                            <Text style={toolbarStyle.menuText}>Done</Text>
                        </TouchableRipple>
                    )
                } else {
                    return (
                        <View style={toolbarStyle.menuItem}>
                            <Text>Done</Text>
                        </View>
                    )

                }
            }
        }
    };

    constructor(props, context) {
        super(props, context);
        this.state = {}
    }

    componentDidMount() {
        this.props.navigation.setParams({
            done: () => {
                if (this.state.id) {
                    this.props.editTodo(this.state.id, this.state.title, this.state.periodUnit, this.state.period);
                } else {
                    this.props.addTodo(this.state.title, this.state.periodUnit, this.state.period);
                }
                this.props.navigation.pop();
            }
        });
    }

    componentDidUpdate(prevProps, prevState, snapshot) {
        if (prevState.canBeSaved !== this.state.canBeSaved) {
            this.props.navigation.setParams({
                canBeSaved: this.state.canBeSaved
            });
        }
    }

    render() {
        console.log(`CreateTodo render state: ${JSON.stringify(this.state)}`);
        console.log(`CreateTodo render props: ${JSON.stringify(this.props)}`);
        return (
            <ScrollView>
                <View style={todoDetailsStyle.root}>
                    <TextInput
                        style={todoDetailsStyle.title}
                        multiline={true}
                        placeholder="Type recurring task name..."
                        onChangeText={title => this.setState({title: title})}
                        value={this.state.title}
                    />
                    <View style={todoDetailsStyle.separatorContainer}>
                        <View style={todoDetailsStyle.separatorLine}/>
                        <Text style={todoDetailsStyle.separatorText}>Repeat</Text>
                    </View>
                    <PeriodSelector periodList={PeriodsList}/>
                </View>
            </ScrollView>
        );
    }

    static getDerivedStateFromProps(props, state) {
        const params = props.navigation.state.params;
        const id = params && params.id ? params.id : undefined;
        console.log(`CreateTodo DerivedState state: ${JSON.stringify(state)}`);
        console.log(`CreateTodo DerivedState props: ${JSON.stringify(props)}`);
        const canBeSaved = !(!state.title || !state.period || !state.periodUnit);
        if (id) {
            const item = props.items.find(todo => todo.id === id);
            return {...initialState, ...item, ...state, id, canBeSaved};
        } else {
            return {...initialState, ...state, canBeSaved};
        }
    }
}

const periodUnitSelectors = (units, selected, amount, onPress) => (
    <View style={todoDetailsStyle.periodUnitContainer}>
        {units.map(function (unit, _) {
            return <PeriodUnitSelector
                unit={unit}
                selectedUnit={selected}
                amount={amount}
                onPress={() => onPress(unit)}/>;
        })}
    </View>
);


export default connect(
    previousState => {
        const {todos} = previousState;
        return {...todos};
    },
    Action
)(DetailsScreen);
