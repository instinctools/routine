import {Button, Picker, TextInput, View} from 'react-native';
import React from 'react';
import {connect} from "react-redux";
import Action from '../action/todos';

export class DetailsScreen extends React.Component {
    constructor() {
        super();
        this.state = {
            title: "",
            periodUnit: Action.Period.DAY,
            period: '1'
        }
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
                    value={this.state.period}
                />
                <Picker
                    selectedValue={this.state.periodUnit}
                    onValueChange={(itemValue, _) => this.setState({periodUnit: itemValue})}>
                    <Picker.Item label={Action.Period.DAY} value={Action.Period.DAY}/>
                    <Picker.Item label={Action.Period.WEEK} value={Action.Period.WEEK}/>
                    <Picker.Item label={Action.Period.MONTH} value={Action.Period.MONTH}/>
                </Picker>
                <Button title={`SAVE CHANGES`} onPress={() => {
                    this.props.addTodo(this.state.title, this.state.periodUnit, this.state.period);
                    this.props.navigation.pop();
                }
                }/>
            </View>
        );
    }
}

export default connect(
    null,
    Action
)(DetailsScreen);
