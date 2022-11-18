import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';

class CountryList extends StatelessWidget {
  final CountryCode Function(CountryCode) onChanged;
  final String initialSelection;

  const CountryList(this.onChanged, this.initialSelection, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(124, 124, 124, 0.3),
          ),
        ),
      ),
      child: CountryListPick(
        appBar: AppBar(
          title: const Text('Choose your Nationality'),
        ),
        pickerBuilder: (context, countryCode) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //circle flag
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  countryCode!.flagUri as String,
                  package: 'country_list_pick',
                  width: 32,
                  height: 32,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  countryCode.name as String,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )),

              const Icon(Icons.arrow_drop_down),
            ],
          );
        },
        initialSelection: initialSelection,
        onChanged: (CountryCode? code) => onChanged(code!),
        useSafeArea: true,
      ),
    );
  }
}
