import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cbr_data_app/presentation/providers/providers.dart';
import 'package:cbr_data_app/data/models/publication.dart';
import 'package:cbr_data_app/data/models/dataset.dart';
import 'package:cbr_data_app/data/models/years.dart';
import 'package:cbr_data_app/data/models/data_response.dart';
import 'package:cbr_data_app/data/repositories/data_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Publication>? categories;
  List<Dataset>? datasets;
  YearsResponse? yearsResponse;
  DataResponse? dataResponse;

  String? selectedPublicationId;
  String? selectedDatasetId;
  bool useDataEx = false; // false = обычный data, true = dataEx
  int? y1;
  int? y2;

  bool isLoading = false;
  String? errorMessage;

  final TextEditingController y1Controller = TextEditingController();
  final TextEditingController y2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(dataRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CBR Data App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Text('Ошибка: $errorMessage', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getCategories(repository),
              child: const Text('Получить публикации'),
            ),
            if (categories != null) _buildCategoriesList(),
            const SizedBox(height: 20),
            if (selectedPublicationId != null) ...[
              ElevatedButton(
                onPressed: () => _getDatasets(repository, selectedPublicationId!),
                child: const Text('Получить датасеты'),
              ),
              if (datasets != null) _buildDatasetsList(),
            ],
            const SizedBox(height: 20),
            if (selectedDatasetId != null) ...[
              ElevatedButton(
                onPressed: () => _getYears(repository, selectedDatasetId!),
                child: const Text('Получить годы'),
              ),
              if (yearsResponse != null) _buildYearsInfo(),
            ],
            const SizedBox(height: 20),
            if (selectedPublicationId != null && selectedDatasetId != null) ...[
              const Text('Годы:'),
              TextField(
                controller: y1Controller,
                decoration: const InputDecoration(labelText: 'Год начала (y1)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: y2Controller,
                decoration: const InputDecoration(labelText: 'Год окончания (y2)'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () => _getData(repository),
                child: const Text('Получить данные'),
              ),
              if (dataResponse != null) _buildDataInfo(),
            ],
          ],
        ),
      ),
    );
  }

  void _getCategories(DataRepository repository) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      print('Fetching categories...');
      categories = await repository.getCategories();
      print('Categories loaded: ${categories?.length}');
    } catch (e) {
      print('Error fetching categories: $e');
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _getDatasets(DataRepository repository, String publicationId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      datasets = await repository.getDatasets(publicationId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _getYears(DataRepository repository, String datasetId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      yearsResponse = await repository.getYears(datasetId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _getData(DataRepository repository) async {
    if (y1Controller.text.isEmpty || y2Controller.text.isEmpty) {
      setState(() {
        errorMessage = 'Введите y1 и y2';
      });
      return;
    }
    y1 = int.tryParse(y1Controller.text);
    y2 = int.tryParse(y2Controller.text);
    if (y1 == null || y2 == null) {
      setState(() {
        errorMessage = 'Неверный формат лет';
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      if (useDataEx) {
        dataResponse = await repository.getDataEx(
          y1: y1!,
          y2: y2!,
          publicationId: selectedPublicationId!,
          datasetId: selectedDatasetId!,
        );
      } else {
        dataResponse = await repository.getData(
          y1: y1!,
          y2: y2!,
          publicationId: selectedPublicationId!,
          datasetId: selectedDatasetId!,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildCategoriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Публикации:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...categories!.map((cat) => ListTile(
          title: Text(cat.categoryName),
          subtitle: Text(cat.id.toString()),
          onTap: () {
            setState(() {
              selectedPublicationId = cat.id.toString();
              datasets = null;
              yearsResponse = null;
              dataResponse = null;
            });
          },
        )),
      ],
    );
  }

  Widget _buildDatasetsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Датасеты:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...datasets!.map((ds) => ListTile(
          title: Text(ds.name ?? 'Без имени'),
          subtitle: Text(ds.id.toString()),
          onTap: () {
            setState(() {
              selectedDatasetId = ds.id.toString();
              yearsResponse = null;
              dataResponse = null;
            });
          },
        )),
      ],
    );
  }

  Widget _buildYearsInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Годы:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('От: ${yearsResponse!.minYear}'),
        Text('До: ${yearsResponse!.maxYear}'),
      ],
    );
  }

  Widget _buildDataInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Данные:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Количество записей: ${dataResponse!.rawData.length}'),
        // Здесь можно добавить график или таблицу
      ],
    );
  }
}