import 'package:doc_warehouse/features/presenter/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';

typedef PageInputBuilder = PageInput Function(
    BuildContext context, VoidCallback runValidator);

class PageViewForm extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final List<PageInputBuilder> pages;

  PageViewForm({required this.pages, required this.onCancel, required this.onSave});

  @override
  State<PageViewForm> createState() => _PageViewFormState();
}

class _PageViewFormState extends State<PageViewForm> {
  final PageController _controller = PageController();
  PageInput? _currentPage;
  bool _isValid = false;
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isFirstPage ? _cancelButton() : _backButton(),
        Expanded(
          child: PageView.builder(
            physics: _isValid ? null : LeftBlockedScrollPhysics(),
            controller: _controller,
            onPageChanged: _updateCurrentPage,
            itemBuilder: _pageBuilder,
            itemCount: widget.pages.length,
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              Spacer(),
              _isLastPage ? _saveButton() : _nextButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cancelButton() => CustomTextButton(
        onPressed: widget.onCancel,
        icon: Icon(Icons.close),
        label: Text('Cancelar'),
      );

  Widget _backButton() => CustomTextButton(
        onPressed: _back,
        icon: Icon(Icons.arrow_back),
        label: Text('Voltar'),
      );

  Widget _saveButton() => CustomTextButton(
        onPressed: _isValid ? widget.onSave : null,
        icon: Icon(Icons.arrow_forward, size: 32),
        label: Text(
          'Salvar',
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        iconPlacement: IconPlacement.right,
      );

  Widget _nextButton() => CustomTextButton(
        onPressed: _isValid ? _next : null,
        icon: Icon(Icons.arrow_forward, size: 32),
        label: Text(
          'Próximo',
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        iconPlacement: IconPlacement.right,
      );

  Widget _pageBuilder(BuildContext context, int pageIndex) {
    _currentPage =
        widget.pages.elementAt(pageIndex)(context, _updateMovementRestrictions);
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _updateMovementRestrictions());
    return _PageInputWidget(_currentPage!);
  }

  bool _runCurrentPageValidator() {
    if (_currentPage?.validator == null) {
      return true;
    } else {
      return _currentPage!.validator!();
    }
  }

  void _updateMovementRestrictions() {
    bool newIsValid = _runCurrentPageValidator();
    if (_isValid != newIsValid) {
      setState(() {
        _isValid = newIsValid;
      });
    }
  }

  void _updateCurrentPage(int newPageIndex) {
    setState(() {
      _currentPageIndex = newPageIndex;
    });
  }

  void _back() {
    _controller.previousPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _next() {
    _controller.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  bool get _isFirstPage => _currentPageIndex == 0;

  bool get _isLastPage => _currentPageIndex == widget.pages.length - 1;
}

class PageInput {
  final Widget title;
  final Widget input;
  final ValueGetter<bool>? validator;

  const PageInput({required this.title, required this.input, this.validator});
}

class _PageInputWidget extends StatelessWidget {
  final PageInput pageInput;

  _PageInputWidget(this.pageInput);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DefaultTextStyle(
            style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 32,
            ),
            child: pageInput.title,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: pageInput.input,
        ),
        Spacer(),
      ],
    );
  }
}
