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
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
              title: Text("Location"),
            ),
            body: DaysPage(),
          );
        },
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
      color: Colors.transparent,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // CREATE IMAGE HERE
        ],
      ),
    );
  }
}

class StatsDataContainer extends StatelessWidget {
  const StatsDataContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      margin: EdgeInsets.symmetric(
        horizontal: defaultPadding / 4,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim,
        borderRadius: BorderRadius.circular(defaultBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [// DATA INSERTION
                  Text(
                    "Time/Date",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                  ),
                  Text(
                    "Weather Desc",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class HoursDataContainer extends StatelessWidget {
  const HoursDataContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding),
          margin: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: defaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryFixedDim,
            borderRadius: BorderRadius.circular(defaultBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [// DATA INSERTION
                      Text(
                        "Time/Date",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                      ),
                      Text(
                        "Weather Desc",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [// DATA INSERTION
                    Text('10*', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    )),
                    Text('-10*', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    )),
                  ],
                ),
                SizedBox(width: 4),
                VerticalDivider(
                  width: defaultDivider,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  indent: 8,
                  endIndent: 8,
                ),
                SizedBox(width: defaultDivider),
                SizedBox( // DATA INSERTION
                  width: defaultIconSize,
                  height: defaultIconSize,
                  child: Icon(
                    Icons.wb_cloudy_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
                ),
                SizedBox(width: defaultDivider * 4),
              ],
            ),
          ),
        ),
        // Positioned dropdown icon
        Positioned(// DATA INSERTION
          top: 4,
          right: 4,
          child: IconButton(
            icon: Icon(Icons.arrow_drop_down_circle, color: Theme.of(context).colorScheme.onPrimary),
            iconSize: 18,
            onPressed: () {
            },
          ),
        ),
      ],
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
