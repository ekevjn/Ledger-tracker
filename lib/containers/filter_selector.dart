import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:vsii_trader/actions/actions.dart';
import 'package:vsii_trader/models/models.dart';
import 'package:vsii_trader/presentation/filter_button.dart';

class FilterSelector extends StatelessWidget {
  final bool visible;

  FilterSelector({Key key, @required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return FilterButton(
          visible: visible,
          activeFilter: vm.activeFilter,
          onSelected: vm.onFilterSelected,
        );
      },
    );
  }
}

class _ViewModel {
  final Function(VisibilityFilter) onFilterSelected;
  final VisibilityFilter activeFilter;

  _ViewModel({
    @required this.onFilterSelected,
    @required this.activeFilter,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onFilterSelected: (filter) {
        store.dispatch(UpdateFilterAction(filter));
      },
      activeFilter: store.state.activeFilter,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          activeFilter == other.activeFilter;

  @override
  int get hashCode => activeFilter.hashCode;
}
