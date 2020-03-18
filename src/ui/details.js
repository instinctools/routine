import {Picker, Text, TextInput, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {connect} from "react-redux";
import Action from '../action/todos';
import {Period} from "../constants";
import {toolbarStyle} from "../styles/Styles";

const initialState = {
    period: 1,
    periodUnit: Period.DAY
};

export class DetailsScreen extends React.Component {

    static navigationOptions = ({navigation}) => {
        return {
            title: '',
            headerRight: () => (
                <TouchableOpacity style={toolbarStyle.menuItem}
                    onPress={navigation.getParam('done')}>
                    <Text style={toolbarStyle.menuText}>Done</Text>
                </TouchableOpacity>
            )
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

    render() {
        console.log(`CreateTodo render state: ${JSON.stringify(this.state)}`);
        console.log(`CreateTodo render props: ${JSON.stringify(this.props)}`);
        return (
            <View>
                <TextInput
                    placeholder="Enter title"
                    onChangeText={title => this.setState({title: title})}
                    value={this.state.title}
                />
                <TextInput
                    keyboardType="numeric"
                    placeholder="Enter period"
                    onChangeText={period => this.setState({period: period})}
                    value={this.state.period.toString()}
                />
                <Picker
                    selectedValue={this.state.periodUnit}
                    onValueChange={(itemValue, _) => this.setState({periodUnit: itemValue})}>
                    <Picker.Item label={Period.DAY} value={Period.DAY}/>
                    <Picker.Item label={Period.WEEK} value={Period.WEEK}/>
                    <Picker.Item label={Period.MONTH} value={Period.MONTH}/>
                </Picker>
                {/*<Button
                    disabled={!this.state.title || !this.state.period || !this.state.periodUnit}
                    title={`SAVE CHANGES`} onPress={() => {
                    if (this.state.id) {
                        this.props.editTodo(this.state.id, this.state.title, this.state.periodUnit, this.state.period);
                    } else {
                        this.props.addTodo(this.state.title, this.state.periodUnit, this.state.period);
                    }
                    this.props.navigation.pop();
                }
                }/>*/}
            </View>
        );
    }

    static getDerivedStateFromProps(props, state) {
        const params = props.navigation.state.params;
        const id = params && params.id ? params.id : undefined;
        console.log(`CreateTodo DerivedState state: ${JSON.stringify(state)}`);
        console.log(`CreateTodo DerivedState props: ${JSON.stringify(props)}`);
        if (id) {
            const item = props.items.find(todo => todo.id === id);
            return {...initialState, ...item, ...state, id};
        } else {
            return {...initialState, ...state};
        }
    }
}

export default connect(
    previousState => {
        const {todos} = previousState;
        return {...todos};
    },
    Action
)(DetailsScreen);
