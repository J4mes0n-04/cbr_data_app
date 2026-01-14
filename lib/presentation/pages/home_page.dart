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
            ElevatedButton.icon(
              onPressed: () => _getCategories(repository),
              icon: const Icon(Icons.list),
              label: const Text('Получить публикации'),
            ),
            if (categories != null) _buildCategoriesList(),
            const SizedBox(height: 20),
            if (selectedPublicationId != null) ...[
              ElevatedButton.icon(
                onPressed: () => _getDatasets(repository, selectedPublicationId!),
                icon: const Icon(Icons.table_chart),
                label: const Text('Получить датасеты'),
              ),
              if (datasets != null) _buildDatasetsList(),
            ],
            const SizedBox(height: 20),
            if (selectedDatasetId != null) ...[
              ElevatedButton.icon(
                onPressed: () => _getYears(repository, selectedDatasetId!),
                icon: const Icon(Icons.calendar_today),
                label: const Text('Получить годы'),
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
              SwitchListTile(
                title: const Text('Использовать dataEx'),
                value: useDataEx,
                onChanged: (value) {
                  setState(() {
                    useDataEx = value;
                  });
                },
              ),
              ElevatedButton.icon(
                onPressed: () => _getData(repository),
                icon: const Icon(Icons.download),
                label: const Text('Получить данные'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Публикации:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Название')),
                DataColumn(label: Text('Выбрать')),
              ],
              rows: categories!.map((cat) => DataRow(
                cells: [
                  DataCell(Text(cat.id.toString())),
                  DataCell(Text(cat.categoryName)),
                  DataCell(ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedPublicationId = cat.id.toString();
                        datasets = null;
                        yearsResponse = null;
                        dataResponse = null;
                      });
                    },
                    child: const Text('Выбрать'),
                  )),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatasetsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Датасеты:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Название')),
                DataColumn(label: Text('Тип')),
                DataColumn(label: Text('Выбрать')),
              ],
              rows: datasets!.map((ds) => DataRow(
                cells: [
                  DataCell(Text(ds.id.toString())),
                  DataCell(Text(ds.name ?? 'Без имени')),
                  DataCell(Text(ds.type.toString())),
                  DataCell(ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDatasetId = ds.id.toString();
                        yearsResponse = null;
                        dataResponse = null;
                      });
                    },
                    child: const Text('Выбрать'),
                  )),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearsInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Годы:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text('От: ${yearsResponse!.minYear}'),
            Text('До: ${yearsResponse!.maxYear}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Данные:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Количество записей: ${dataResponse!.rawData.length}'),
            if (dataResponse!.rawData.isNotEmpty)
              DataTable(
                columns: const [
                  DataColumn(label: Text('Дата')),
                  DataColumn(label: Text('Значение')),
                ],
                rows: dataResponse!.rawData.map((data) => DataRow(
                  cells: [
                    DataCell(Text(data.dt)),
                    DataCell(Text(data.obsVal.toString())),
                  ],
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }
}