import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import '../../models/resource_link_model.dart';

class ResourceLinkChip extends StatelessWidget {
  final ResourceLinkModel link;

  const ResourceLinkChip({
    super.key,
    required this.link,
  });

  Future<void> _launch() async {
    final uri = Uri.parse(link.url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (link.type) {
      case ResourceType.youtube:
        icon = Icons.play_circle_fill_rounded;
        color = const Color(0xFFFF0000);
        break;
      case ResourceType.github:
        icon = Icons.code_rounded;
        color = const Color(0xFFE2E8F0);
        break;
      case ResourceType.figma:
        icon = Icons.design_services_rounded;
        color = const Color(0xFFA259FF);
        break;
      case ResourceType.devpost:
        icon = Icons.bolt_rounded;
        color = AppColors.flameOrange;
        break;
      case ResourceType.article:
        icon = Icons.article_rounded;
        color = AppColors.cyanPrimary;
        break;
      case ResourceType.doc:
        icon = Icons.description_rounded;
        color = const Color(0xFF3B82F6);
        break;
      case ResourceType.general:
        icon = Icons.link_rounded;
        color = AppColors.emeraldGreen;
        break;
    }

    return InkWell(
      onTap: _launch,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                link.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.open_in_new_rounded, size: 10, color: color.withValues(alpha: 0.8)),
          ],
        ),
      ),
    );
  }
}
