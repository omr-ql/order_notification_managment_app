import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/product_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/order_provider.dart';
import '../providers/notification_provider.dart';
import '../utils/responsive_utils.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: ResponsiveUtils.getScreenPadding(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Analytics Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: isMobile ? 20 : 24,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8 : 12,
                        vertical: isMobile ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.update,
                            color: Theme.of(context).colorScheme.primary,
                            size: ResponsiveUtils.getButtonIconSize(context),
                          ),
                          SizedBox(width: isMobile ? 2 : 4),
                          Text(
                            'Real-time Data',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 10 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Key Metrics Section
              if (isMobile) ...[
                RevenueMetricCard(),
                const SizedBox(height: 16),
                OrdersMetricCard(),
                const SizedBox(height: 16),
                CustomersMetricCard(),
                const SizedBox(height: 16),
                NotificationsMetricCard(),
              ] else ...[
                Row(
                  children: [
                    Expanded(child: RevenueMetricCard()),
                    const SizedBox(width: 16),
                    Expanded(child: OrdersMetricCard()),
                    const SizedBox(width: 16),
                    Expanded(child: CustomersMetricCard()),
                    const SizedBox(width: 16),
                    Expanded(child: NotificationsMetricCard()),
                  ],
                ),
              ],

              const SizedBox(height: 32),

              // Charts Section
              if (isMobile) ...[
                OrderStatusChart(),
                const SizedBox(height: 16),
                CategoryDistributionChart(),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: OrderStatusChart(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: CategoryDistributionChart(),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 32),

              // Additional Analytics
              if (isMobile) ...[
                CustomerBalanceChart(),
                const SizedBox(height: 16),
                NotificationSuccessChart(),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: CustomerBalanceChart()),
                    const SizedBox(width: 16),
                    Expanded(child: NotificationSuccessChart()),
                  ],
                ),
              ],

              const SizedBox(height: 32),

              // Performance Metrics
              PerformanceMetricsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class RevenueMetricCard extends StatelessWidget {
  const RevenueMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        return MetricCard(
          title: 'Total Revenue',
          value: '\$${provider.totalRevenue.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
          subtitle: 'From ${provider.totalOrdersCount} orders',
        );
      },
    );
  }
}

class OrdersMetricCard extends StatelessWidget {
  const OrdersMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        return MetricCard(
          title: 'Total Orders',
          value: '${provider.totalOrdersCount}',
          icon: Icons.shopping_cart,
          color: Theme.of(context).colorScheme.primary,
          subtitle: '${provider.pendingOrdersCount} pending',
        );
      },
    );
  }
}

class CustomersMetricCard extends StatelessWidget {
  const CustomersMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        return MetricCard(
          title: 'Total Customers',
          value: '${provider.customers.length}',
          icon: Icons.people,
          color: Theme.of(context).colorScheme.secondary,
          subtitle: '${provider.elDokkiCustomersCount} in El-Dokki',
        );
      },
    );
  }
}

class NotificationsMetricCard extends StatelessWidget {
  const NotificationsMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        return MetricCard(
          title: 'Notifications Sent',
          value: '${provider.totalSentCount}',
          icon: Icons.notifications,
          color: Colors.purple,
          subtitle: '${provider.successRate.toStringAsFixed(1)}% success rate',
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: ResponsiveUtils.getCardPadding(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: ResponsiveUtils.getIconSize(context),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 14 : 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: isMobile ? 11 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderStatusChart extends StatelessWidget {
  const OrderStatusChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: ResponsiveUtils.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 16 : 20,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            SizedBox(
              height: isMobile ? 200 : 300,
              child: Consumer<OrderProvider>(
                builder: (context, provider, child) {
                  final statusCounts = provider.getOrderStatusCounts();

                  if (statusCounts.values.every((count) => count == 0)) {
                    return Center(
                      child: Text(
                        'No order data available',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                    );
                  }

                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: statusCounts.values.reduce((a, b) => a > b ? a : b).toDouble() + 2,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final statuses = statusCounts.keys.toList();
                              if (value.toInt() < statuses.length) {
                                return Text(
                                  statuses[value.toInt()],
                                  style: TextStyle(fontSize: isMobile ? 10 : 12),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: isMobile ? 10 : 12),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: statusCounts.entries.map((entry) {
                        final index = statusCounts.keys.toList().indexOf(entry.key);
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              color: _getStatusColor(entry.key),
                              width: isMobile ? 16 : 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'placed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class CategoryDistributionChart extends StatelessWidget {
  const CategoryDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: ResponsiveUtils.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 16 : 20,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            SizedBox(
              height: isMobile ? 200 : 300,
              child: Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  final categoryStock = provider.categoryStock;

                  if (categoryStock.isEmpty) {
                    return Center(
                      child: Text(
                        'No category data available',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                    );
                  }

                  return PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: isMobile ? 30 : 40,
                      sections: categoryStock.entries.map((entry) {
                        final index = categoryStock.keys.toList().indexOf(entry.key);
                        return PieChartSectionData(
                          color: _getCategoryColor(index),
                          value: entry.value.toDouble(),
                          title: '${entry.value}',
                          radius: isMobile ? 60 : 80,
                          titleStyle: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: provider.categoryStock.entries.map((entry) {
                    final index = provider.categoryStock.keys.toList().indexOf(entry.key);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: isMobile ? 2 : 4),
                      child: Row(
                        children: [
                          Container(
                            width: isMobile ? 12 : 16,
                            height: isMobile ? 12 : 16,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(index),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: isMobile ? 6 : 8),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: TextStyle(fontSize: isMobile ? 12 : 14),
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: TextStyle(fontSize: isMobile ? 12 : 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}

class CustomerBalanceChart extends StatelessWidget {
  const CustomerBalanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: ResponsiveUtils.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Balance Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 16 : 20,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            SizedBox(
              height: isMobile ? 180 : 250,
              child: Consumer<CustomerProvider>(
                builder: (context, provider, child) {
                  final customers = provider.customers;

                  if (customers.isEmpty) {
                    return Center(
                      child: Text(
                        'No customer data available',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                    );
                  }

                  final balanceRanges = {
                    '0-500': 0,
                    '500-1000': 0,
                    '1000-2000': 0,
                    '2000+': 0,
                  };

                  for (final customer in customers) {
                    if (customer.balance <= 500) {
                      balanceRanges['0-500'] = balanceRanges['0-500']! + 1;
                    } else if (customer.balance <= 1000) {
                      balanceRanges['500-1000'] = balanceRanges['500-1000']! + 1;
                    } else if (customer.balance <= 2000) {
                      balanceRanges['1000-2000'] = balanceRanges['1000-2000']! + 1;
                    } else {
                      balanceRanges['2000+'] = balanceRanges['2000+']! + 1;
                    }
                  }

                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: balanceRanges.values.reduce((a, b) => a > b ? a : b).toDouble() + 1,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final ranges = balanceRanges.keys.toList();
                              if (value.toInt() < ranges.length) {
                                return Text(
                                  ranges[value.toInt()],
                                  style: TextStyle(fontSize: isMobile ? 9 : 12),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: isMobile ? 10 : 12),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: balanceRanges.entries.map((entry) {
                        final index = balanceRanges.keys.toList().indexOf(entry.key);
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              color: Theme.of(context).colorScheme.secondary,
                              width: isMobile ? 16 : 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSuccessChart extends StatelessWidget {
  const NotificationSuccessChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: ResponsiveUtils.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Success Rate',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 16 : 20,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            SizedBox(
              height: isMobile ? 180 : 250,
              child: Consumer<NotificationProvider>(
                builder: (context, provider, child) {
                  final successRate = provider.successRate;
                  final failureRate = 100 - successRate;

                  return PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: isMobile ? 40 : 60,
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: successRate,
                          title: '${successRate.toStringAsFixed(1)}%',
                          radius: isMobile ? 60 : 80,
                          titleStyle: TextStyle(
                            fontSize: isMobile ? 12 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: failureRate,
                          title: '${failureRate.toStringAsFixed(1)}%',
                          radius: isMobile ? 60 : 80,
                          titleStyle: TextStyle(
                            fontSize: isMobile ? 12 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      width: isMobile ? 12 : 16,
                      height: isMobile ? 12 : 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: isMobile ? 6 : 8),
                    Text(
                      'Success',
                      style: TextStyle(fontSize: isMobile ? 12 : 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: isMobile ? 12 : 16,
                      height: isMobile ? 12 : 16,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: isMobile ? 6 : 8),
                    Text(
                      'Failed',
                      style: TextStyle(fontSize: isMobile ? 12 : 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PerformanceMetricsCard extends StatelessWidget {
  const PerformanceMetricsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: ResponsiveUtils.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Performance Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 16 : 20,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            Consumer4<ProductProvider, CustomerProvider, OrderProvider, NotificationProvider>(
              builder: (context, productProvider, customerProvider, orderProvider, notificationProvider, child) {
                return Column(
                  children: [
                    _buildMetricRow(
                      context,
                      'Average Order Value',
                      '\$${orderProvider.averageOrderValue.toStringAsFixed(2)}',
                      Icons.trending_up,
                      Colors.green,
                    ),
                    _buildMetricRow(
                      context,
                      'Customer Retention Rate',
                      '${((customerProvider.elDokkiCustomersCount / (customerProvider.customers.length > 0 ? customerProvider.customers.length : 1)) * 100).toStringAsFixed(1)}%',
                      Icons.people,
                      Theme.of(context).colorScheme.secondary,
                    ),
                    _buildMetricRow(
                      context,
                      'Inventory Turnover',
                      '${(productProvider.products.length / ((productProvider.categoryStock.values.fold(0, (a, b) => a + b) / (productProvider.products.length > 0 ? productProvider.products.length : 1)))).toStringAsFixed(1)}x',
                      Icons.inventory,
                      Theme.of(context).colorScheme.primary,
                    ),
                    _buildMetricRow(
                      context,
                      'Notification Efficiency',
                      '${notificationProvider.successRate.toStringAsFixed(1)}%',
                      Icons.notifications_active,
                      Colors.purple,
                    ),
                    _buildMetricRow(
                      context,
                      'Order Fulfillment Rate',
                      '${((orderProvider.deliveredOrdersCount / (orderProvider.totalOrdersCount > 0 ? orderProvider.totalOrdersCount : 1)) * 100).toStringAsFixed(1)}%',
                      Icons.local_shipping,
                      Colors.orange,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: ResponsiveUtils.getIconSize(context),
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: isMobile ? 13 : 16,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: isMobile ? 16 : 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
