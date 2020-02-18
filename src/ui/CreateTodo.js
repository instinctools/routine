import {Button, Picker, TextInput, View} from 'react-native';
import React from 'react';
import {PERIOD_DAY, PERIOD_MONTH, PERIOD_WEEK} from "../data/Reducer";
import {addTodo} from "../data/Action";


export class CreateTodo extends React.Component {
    constructor() {
        super();
        this.state = {
            title: "",
            periodUnit: PERIOD_DAY,
            period: 1
        }
    }

    render() {
        return (
            <View>
                <TextInput
                    placeholder="Enter title"
                    onChangeText={title => this.setState({title: title})}
                />
                <TextInput
                    keyboardType="numeric"
                    placeholder="Enter period"
                    onChangeText={period => this.setState({period: period})}
                />
                <Picker
                    selectedValue={this.state.periodUnit}
                    onValueChange={(itemValue, _) => this.setState({periodUnit: itemValue})}>
                    <Picker.Item label={PERIOD_DAY} value={PERIOD_DAY}/>
                    <Picker.Item label={PERIOD_WEEK} value={PERIOD_WEEK}/>
                    <Picker.Item label={PERIOD_MONTH} value={PERIOD_MONTH}/>
                </Picker>
                <Button title={`SAVE CHANGES`} onPress={() => {
                    addTodo(this.state.title, this.state.periodUnit, this.state.period);
                    this.props.navigation.pop();
                }
                }/>
            </View>
        );
    }
}
