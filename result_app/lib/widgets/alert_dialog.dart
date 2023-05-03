import 'package:flutter/material.dart';

Future showAlertDialog({
  @required BuildContext context,
  @required String title,
  @required Color titleColor,
  @required String content,
  @required String option1,
  @required Color option1Color,
  @required Function option1Func,
  @required String option2,
  @required Color option2Color,
  @required Function option2Func,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (content != null)
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (option1 != null)
                      OutlinedButton(
                        onPressed: option1Func,
                        child: Text(
                          option1,
                          style: TextStyle(
                            color: option1Color,
                          ),
                        ),
                      ),
                    const SizedBox(
                      width: 15,
                    ),
                    if (option2 != null)
                      OutlinedButton(
                        onPressed: option2Func,
                        child: Text(
                          option2,
                          style: TextStyle(
                            color: option2Color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
