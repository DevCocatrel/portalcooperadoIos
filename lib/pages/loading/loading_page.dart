import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage(this.future, {super.key});

  final Future<bool> future;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool loadingCompleted = false;
  bool showSuccess = false;
  bool showError = false;

  bool? successFuture;

  Future<void> executeFuture() async {
    successFuture = await widget.future;

    _controller.animateTo(1, duration: const Duration(seconds: 3)).then((_) {
      setState(() {
        loadingCompleted = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(minutes: 3),
      vsync: this,
    );

    executeAnimation();
    executeFuture();
  }

  executeAnimation({double? from}) {
    _controller.forward(from: from).then((_) {
      executeAnimation(from: .1);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          leading: const SizedBox(),
          centerTitle: true,
          title: Image.asset(
            AppAssets.logo,
            fit: BoxFit.fill,
            height: 24,
          ),
        ),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 58),
                width: double.maxFinite,
                child: showError
                    ? errorCenterWidget()
                    : showSuccess
                        ? successCenterWidget()
                        : loadingCenterWidget(),
              ),
              const Spacer(),
              showError || showSuccess
                  ? successButtonsWidget()
                  : loadingWarningWidget(),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedOpacity loadingWarningWidget() {
    return AnimatedOpacity(
      duration: const Duration(seconds: 2),
      opacity: loadingCompleted ? 0 : 1,
      child: DefaultCardWidget(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 36).copyWith(bottom: 56),
        child: Column(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Esse processo pode demorar alguns segundos, não saia desta tela até que a nota seja emitida!',
              style: AppFonts.text.copyWith(
                color: AppColors.textColorLight,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Column successButtonsWidget() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
              ..pop()
              ..pop(0);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets.exportNotes,
                colorFilter: const ColorFilter.mode(
                  AppColors.buttonTextLight,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Emitir nova NFE',
                style: AppFonts.textButton,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
              ..pop()
              ..pop(1);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Notas Emitidas',
                style: AppFonts.textButton,
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.buttonTextLight,
              )
            ],
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  AnimatedOpacity loadingCenterWidget() {
    return AnimatedOpacity(
      duration: const Duration(seconds: 2),
      onEnd: () {
        showSuccess = successFuture ?? false;
        showError = !(successFuture ?? false);
        setState(() {});
      },
      opacity: loadingCompleted ? 0 : 1,
      child: Column(
        children: [
          AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Stack(
                  children: [
                    SizedBox(
                      height: 86,
                      width: 86,
                      child: CircularProgressIndicator(
                        value: _controller.value,
                        color: AppColors.primaryColor,
                        backgroundColor: AppColors.primaryLight,
                        strokeCap: StrokeCap.round,
                        strokeWidth: 6,
                      ),
                    ),
                    Positioned(
                      bottom: .0,
                      top: .0,
                      left: .0,
                      right: .0,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('${(_controller.value * 100).toInt()}%'),
                      ),
                    ),
                  ],
                );
              }),
          const SizedBox(height: 26),
          Text(
            'Estamos emitindo a sua Nota Fiscal de entrada de café',
            textAlign: TextAlign.center,
            style: AppFonts.text.copyWith(
              color: AppColors.textColorLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget successCenterWidget() {
    return Column(
      children: [
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.successLight,
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 38,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Tudo certo!\nNota fiscal emitida com sucesso.',
          textAlign: TextAlign.center,
          style: AppFonts.text.copyWith(
            color: AppColors.textColorLight,
          ),
        ),
      ],
    );
  }

  Widget errorCenterWidget() {
    return Column(
      children: [
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.dangerLight,
          ),
          child: const Center(
            child: Icon(
              Icons.cancel_outlined,
              size: 38,
              color: AppColors.danger,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Erro ao gerar nota fiscal\nEntre em contato com a Cocatrel ou tente novamente.',
          textAlign: TextAlign.center,
          style: AppFonts.text.copyWith(
            color: AppColors.textColorLight,
          ),
        ),
      ],
    );
  }
}
