import 'package:doc_warehouse/app_guard.dart';
import 'package:doc_warehouse/core/database/app_database.dart';
import 'package:doc_warehouse/core/utils/date_formatter.dart';
import 'package:doc_warehouse/core/utils/file_data_loader.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource_impl.dart';
import 'package:doc_warehouse/features/data/repository/document_repository_impl.dart';
import 'package:doc_warehouse/features/domain/usecases/create_document_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/get_document_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:doc_warehouse/features/presenter/pages/create_document_page.dart';
import 'package:doc_warehouse/features/presenter/pages/list_documents_page.dart';
import 'package:doc_warehouse/features/presenter/pages/view_document_page.dart';
import 'package:doc_warehouse/routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    AsyncBind((i) => AppDatabaseFactory.getInstance()),
    Bind((i) => DocumentRepositoryImpl(i())),
    Bind((i) => DocumentDatasourceImpl(i())),
    Bind((i) => GetDocumentsUsecase(i()), isSingleton: false),
    Bind((i) => CreateDocumentUsecase(i()), isSingleton: false),
    Bind((i) => GetDocumentUsecase(i()), isSingleton: false),
    Bind((i) => DateFormatter()),
    Bind((i) => FileDataLoader()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Routes.listDocuments,
      child: (_, __) => ListDocumentsPage(),
      guards: [AppGuard()],
    ),
    ChildRoute(
      Routes.createDocument,
      child: (_, __) => CreateDocumentPage(),
      guards: [AppGuard()],
    ),
    ChildRoute(
      Routes.viewDocument,
      child: (_, route) => ViewDocumentPage(route.data),
      guards: [AppGuard()],
    )
  ];
}
