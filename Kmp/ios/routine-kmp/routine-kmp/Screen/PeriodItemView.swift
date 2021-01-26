import SwiftUI
import RoutineShared

struct PeriodItemView: View {
    
    let period: PeriodUnitUiModel
    let selected: Bool
    
    let textColor: Color
    let backgroundColor: Color
    
    init(period: PeriodUnitUiModel, selected: Bool) {
        self.period = period
        self.selected = selected
        
        if selected {
            self.textColor = Color(red: 0.882, green: 0.882, blue: 0.878)
            self.backgroundColor = Color(red: 0.467, green: 0.463, blue: 0.49)
        } else {
            self.textColor = Color(red: 0.678, green: 0.682, blue: 0.686)
            self.backgroundColor = Color(red: 0.933, green: 0.929, blue: 0.937)
        }
    }
    
    var body: some View {
        HStack {
            Image("Period Selection")
            Spacer()
            Text(period.unit.title(count: Int(period.count)))
                .font(.title2)
        }
        .padding(12)
        .foregroundColor(textColor)
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

struct PeriodItemView_Previews: PreviewProvider {
    static var previews: some View {
        let period = PeriodUnitUiModel(unit: PeriodUnit.week, count: 2)
        let period2 = PeriodUnitUiModel(unit: PeriodUnit.day, count: 0)
        VStack {
            PeriodItemView(period: period, selected: true)
            PeriodItemView(period: period2, selected: false)
        }
    }
}
