import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_book/bloc/measure.bloc.dart';
import 'package:tailor_book/constants/color.dart';
import 'package:tailor_book/models/personnel.model.dart';
import 'package:tailor_book/widgets/personnel/select_personnel.widget.dart';
import 'package:tailor_book/widgets/shared/custom_button.widget.dart';
import 'package:tailor_book/widgets/shared/loadingSpinner.dart';
import 'package:tailor_book/widgets/shared/toast.dart';

class LinkCouturierPage extends StatelessWidget {
  final String measureId;
  const LinkCouturierPage({
    super.key,
    required this.measureId,
  });

  @override
  Widget build(BuildContext context) {
    Personnel selectedPersonnel = Personnel();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Affectation de la mesure",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          children: [
            SelectPersonnel(
              onPressed: (value) {
                selectedPersonnel = value;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 75,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: BlocBuilder<MeasureBloc, MeasureStates>(
          builder: (builderContext, state) {
            if (state is MeasureLoadingState) {
              return const LoadingSpinner();
            } else if (state is MeasureErrorState) {
              showToast(builderContext, state.errorMessage, "error");
            } else if (state is MeasureSuccessState) {
              showToast(builderContext, state.successMessage, "success");
              onGoBack(context, true);
            }
            return CustomButton(
              buttonText: "Affecter",
              buttonColor: primaryColor,
              borderColor: primaryColor,
              btnTextColor: kWhite,
              buttonSize: 18,
              buttonFonction: () {
                log("${selectedPersonnel.firstName}");
                builderContext.read<MeasureBloc>().add(
                      AffectationMeasurementEvent(
                        measureId: measureId,
                        personnel: selectedPersonnel,
                      ),
                    );
              },
            );
          },
        ),
      ),
    );
  }

  void showToast(BuildContext buildContext, String message, String type) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Toast.showFlutterToast(
          buildContext,
          message,
          type,
        );
      },
    );
  }

  void onGoBack(BuildContext context, bool response) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.pop(context, response);
      },
    );
  }
}
