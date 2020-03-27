import {ScrollView, Text, TextInput, View} from 'react-native';
import React from 'react';
import {connect} from "react-redux";
import {todoDetailsStyle, toolbarStyle} from "../../styles/Styles";
import {TouchableRipple} from "react-native-paper";
import PeriodSelector from "./PeriodSelector";
import ActionEditTodo from "../../action/EditTodoAction";

class DetailsScreen extends React.Component {

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

    componentDidMount() {
        this.props.navigation.setParams({
            done: () => {
                if (this.state.id) {
                    // this.props.editTodo(this.state.id, this.state.title, this.state.periodUnit, this.state.period);
                } else {
                    // this.props.addTodo(this.state.title, this.state.periodUnit, this.state.period);
                }
                this.props.navigation.pop();
            }
        });
    }

    componentDidUpdate(prevProps, prevState, snapshot) {
        if (prevProps.canBeSaved !== this.props.canBeSaved) {
            this.props.navigation.setParams({
                canBeSaved: this.props.canBeSaved
            });
        }
    }

    render() {
        console.log(`DetailsScreen render props: ${JSON.stringify(this.props)}`);
        return (
            <ScrollView>
                <View style={todoDetailsStyle.root}>
                    <TextInput
                        style={todoDetailsStyle.title}
                        multiline={true}
                        placeholder="Type recurring task name..."
                        onChangeText={title => this.props.editTodoTitle(title)}
                    />
                    <View style={todoDetailsStyle.separatorContainer}>
                        <View style={todoDetailsStyle.separatorLine}/>
                        <Text style={todoDetailsStyle.separatorText}>Repeat</Text>
                    </View>
                    <PeriodSelector/>
                </View>
            </ScrollView>
        );
    }
}

const mapStateToProps = (state) => {
    return {
        canBeSaved: !(!state.editTodo.title || !state.editTodo.period || !state.editTodo.periodUnit)
    }
};

export default connect(
    mapStateToProps,
    ActionEditTodo
)(DetailsScreen);
