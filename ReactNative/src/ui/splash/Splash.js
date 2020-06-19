import React from "react";
import {ActivityIndicator, Image, Text, View} from "react-native";
import {connect} from "react-redux";
import SplashAction from "../../action/SplashAction";
import {TouchableRipple} from "react-native-paper";
import {splashStyle} from "../../styles/Styles";

class DetailsScreen extends React.Component {
    static navigationOptions = {
        header: null
    };

    render() {
        let {isProgress, isSuccess, isError} = this.props.splash
        if (isSuccess) {
            props.navigation.navigate("Items")
        }
        let text = isProgress ? "Setting up account" : "An error occurred!"

        return <View style={{
            flex: 1,
        }}>
            <View style={{flex: 1, justifyContent: 'center'}}>
                <Image
                    style={splashStyle.image}
                    //TODO Check if it possible to replace by svg
                    source={require('./splash.png')}
                />

            </View>

            <View style={{flex: 1, alignItems: 'center'}}>
                <Text style={splashStyle.message}>{text}</Text>
                {
                    isProgress ?
                        getProgress() :
                        <TouchableRipple
                            style={splashStyle.retryBtn}
                            onPress={() => {

                            }}
                            borderless={true}
                        >
                            <Text style={splashStyle.retryBtnText}>Retry</Text>
                        </TouchableRipple>
                }
            </View>
        </View>
    }
}


const getProgress = () => {
    return (Platform.OS === 'ios') ?
        <ActivityIndicator style={{marginTop: 32}} size="large"/> :
        <ActivityIndicator style={{marginTop: 32}} color="#835D51" size={48}/>
}

const mapStateToProps = (state) => {
    return {
        splash: state.splash
    }
};

export default connect(
    mapStateToProps, {
        ...SplashAction
    }
)(DetailsScreen);
