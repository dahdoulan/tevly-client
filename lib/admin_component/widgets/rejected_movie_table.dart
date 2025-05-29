import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/admin_component/providers/admin_provider.dart';
import 'package:tevly_client/admin_component/services/preview_movie.dart';
import 'package:tevly_client/admin_component/services/preview_thumbnail.dart';

class RejectedMoviesTable extends StatelessWidget {
  const RejectedMoviesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminDashboardProvider>(context);
    
   return DataTable(
      showCheckboxColumn: false,
      horizontalMargin: 16,
      columnSpacing: 24,
      border: TableBorder.all(
        color: Colors.grey.shade300,
        width: 1,
        borderRadius: BorderRadius.circular(8),
      ),
      headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
      dataRowHeight: 60,
      columns: const [
        DataColumn(
          label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Filmmaker', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      rows: provider.rejectedMovies.map((movie) {
        return DataRow(cells: [
          DataCell(
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Text(
                movie['title'] ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          DataCell(
            Container(
              constraints: const BoxConstraints(maxWidth: 2000),
              child: Text(
                movie['description'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          DataCell(Text(movie['filmmakerFullName'] ?? 'Unknown')),
          DataCell(Text(movie['filmmakerEmail'] ?? '')),
          DataCell(
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                movie['category'] ?? 'Uncategorized',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          DataCell(Text(movie['date']?.toString().substring(0, 10) ?? '')),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () => PreviewThumbnail.previewThumbnail(context, movie),
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => Previewmovie.previewMovie(context, movie),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => provider.handleApprove(context, movie),
                ),
              ],
            ),
          ),
        ]);
      }).toList(),
    );
  }
}