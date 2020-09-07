import {StyleSheet} from 'react-native';

export const todoListStyle = StyleSheet.create({
    errorMessage:{
        color: `#835D51`,
        textAlign: "center",
        fontSize: 24,
        fontWeight: 'bold'
    },
    emptyListImage:{
        width: 124, height: 124
    },
    emptyListTitle:{
        fontSize: 20,
        fontWeight: 'bold',
        textAlign: `center`,
        color: `#4E4E53`
    },
    emptyListDescription:{
        marginTop: 8,
        fontSize: 16,
        textAlign: `center`,
        color: `#9A99A2`
    },
    container: {
        paddingTop: 12,
        paddingBottom: 12
    },
    item: {
        flexDirection: `column`,
        padding: 8,
        marginBottom: 4,
        borderRadius: 10,
        marginHorizontal: 16,
        marginVertical: 4
    },
    itemHeader: {
        flexDirection: `row`,
        justifyContent: 'space-between',
    },
    itemFooter: {
        flexDirection: `row`,
        justifyContent: 'space-between',
        fontSize: 14,
    },
    itemHeaderText:{
        fontSize: 18,
        color: `#ffffff`
    },
    itemFooterText:{
        fontSize: 14,
        color: `rgba(255, 255, 255, 0.7)`
    },
    itemSwipeContent:{
        flex: 1,
        justifyContent: `center`,
        alignItems: `center`,
        width: 96,
        borderRadius: 10,
        marginVertical: 4
    },
    itemSwipeText:{
        fontSize:20,
        color: `#FFFFFF`
    },
    itemExpiredSeparator:{
        height: 1,
        marginVertical: 12,
        marginHorizontal: 16,
        backgroundColor: "rgba(0,0,0,0.2)"
    }
});

export const todoDetailsStyle = StyleSheet.create({
    root: {
        marginHorizontal: 16,
    },
    title: {
        fontSize: 30
    },
    period: {
        padding: 8,
    },
    periodUnitContainer: {
        padding: 8,
        flexDirection: `row`,
        justifyContent: 'space-evenly',
    },
    separatorContainer: {
        marginTop: 30,
        flexDirection: `row`,
        alignItems: `center`
    },
    separatorLine: {
        flex: 1,
        height: 1,
        backgroundColor: `#AAA9A9`
    },
    separatorText: {
        marginLeft: 24,
        flexGrow: 1,
        paddingHorizontal: 16,
        backgroundColor: `#ffffff`,
        color: `#AAA9A9`,
        fontSize: 16,
        position: 'absolute',
        alignSelf: 'center'
    },
    periodUnitSelectorContainer:{
        borderRadius: 10,
        marginVertical: 8
    },
    periodUnitSelectorContainerWrapper:{
        flexDirection: `row`,
        flex: 1,
        marginTop: 8,
        marginBottom: 8
    },
    periodUnitSelectorText:{
        flex: 1,
        fontSize: 20,
        textAlignVertical: `center`,
        marginRight: 16
    },
    periodSelectorContainer: {
        flex: 1,
        justifyContent: `flex-end`,
        backgroundColor: `rgba(0, 0, 0, 0.2)`
    },
    periodSelectorCancelWrapper: {
        backgroundColor: `#FFFFFF`,
        borderRadius: 16
    },
    periodSelectorInfo: {
        flex: 1,
        fontWeight: `bold`,
        marginStart: 16,
        alignSelf: `center`,
        color: `#9E9DA8`,
        fontSize: 16
    },
    periodSelectorCancel: {
        borderRadius: 16,
        alignSelf: 'flex-start',
        padding: 16
    },
    periodSelectorPicker: {
        backgroundColor: `#F1F1F1`
    }
});

export const toolbarStyle = StyleSheet.create({
    title: {
        fontSize: 32,
        fontWeight: 'bold'
    },
    menuItem:{
        width: 48,
        height: 48,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 32
    },
    menuText: {
        fontWeight: 'bold'
    }
});

export const splashStyle = StyleSheet.create({
    image: {
        width: 196, height: 196, alignSelf: `center`
    },
    message:{
        color: `#835D51`,
        textAlign: "center",
        fontSize: 18,
        fontWeight: 'bold'
    },
    retryBtn:{
        justifyContent: `center`,
        alignItems: `center`,
        marginTop: 32,
        borderRadius: 8,
        backgroundColor: `#835D51`,
        width: 156,
        height: 50
    },
    retryBtnText:{
        fontSize: 16,
        color: `#ffffff`
    }
})
