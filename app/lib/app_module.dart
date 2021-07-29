import 'package:doc_warehouse/app_guard.dart';
import 'package:doc_warehouse/core/database/app_database.dart';
import 'package:doc_warehouse/core/utils/date_formatter.dart';
import 'package:doc_warehouse/core/utils/file_data_loader.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource_impl.dart';
import 'package:doc_warehouse/features/data/repository/document_repository_impl.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/usecases/create_document_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/delete_document_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/get_document_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/get_documents_usecase.dart';
import 'package:doc_warehouse/features/domain/usecases/update_document_usecase.dart';
import 'package:doc_warehouse/features/presenter/pages/create_document_page.dart';
import 'package:doc_warehouse/features/presenter/pages/list_documents_page.dart';
import 'package:doc_warehouse/features/presenter/pages/update_document_page.dart';
import 'package:doc_warehouse/features/presenter/pages/view_document_page.dart';
import 'package:doc_warehouse/routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    AsyncBind((i) => AppDatabaseFactory.createInstance()),
    Bind((i) => DocumentRepositoryImpl(i())),
    Bind((i) => DocumentDataSourceImpl(i())),
    Bind((i) => GetDocumentsUseCase(i()), isSingleton: false),
    Bind((i) => CreateDocumentUseCase(i()), isSingleton: false),
    Bind((i) => UpdateDocumentUseCase(i()), isSingleton: false),
    Bind((i) => GetDocumentUseCase(i()), isSingleton: false),
    Bind((i) => DeleteDocumentUseCase(i()), isSingleton: false),
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
      Routes.editDocument,
      child: (_, route) {
        print(route.data);
        if (route.data is Document) {
          return UpdateDocumentPage(route.data);
        }
        throw Exception('The "${Routes.editDocument}" route must receive a document as parameter');
      },
      guards: [AppGuard()],
    ),
    ChildRoute(
      Routes.viewDocument,
      child: (_, route) => ViewDocumentPage(route.data),
      guards: [AppGuard()],
    )
  ];
}
