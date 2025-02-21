import 'package:flutter/material.dart';
import 'constants.dart';
import 'util.dart';
import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieves the default theme for the platform
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    // TextTheme textTheme = Theme.of(context).textTheme;
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text("Location"),
        ),
        body: DaysPage(),
      ),
    );
  }
}

class DaysPage extends StatefulWidget {
  const DaysPage({super.key});

  @override
  State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          hoursContainer(),
          hoursContainer(),
          hoursContainer(),
          hoursContainer(),
        ],
      ),
    );
  }
}

class hoursContainer extends StatelessWidget {
  const hoursContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultBorder),
      margin: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: defaultBorder / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(defaultBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Ensures full heightRow(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "Weather Desc",
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(
                      color:
                      Theme.of(
                        context,
                      ).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('M', style: Theme.of(context).textTheme.bodyLarge),
                Text('N', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            SizedBox(width: 4),
            VerticalDivider(
              width: 20,
              // total space taken by the divider
              thickness: 2,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              indent: 0,
              endIndent: 0,
            ),
            SizedBox(width: 8),
            Container(
              width: defaultIconSize,
              height: defaultIconSize,
              child: Icon(
                Icons.wb_cloudy_outlined,
                size: 40,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
