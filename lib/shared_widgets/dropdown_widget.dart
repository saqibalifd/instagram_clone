import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_theme.dart';

/// A beautiful, animated custom dropdown widget
class DropdownWidget extends StatefulWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final IconData? prefixIcon;

  const DropdownWidget({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<double>(
      begin: -8,
      end: 0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _closeDropdown();
    _animController.dispose();
    super.dispose();
  }

  void _openDropdown() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _animController.forward();
  }

  void _closeDropdown() {
    _animController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _isOpen = false);
    });
  }

  void _toggleDropdown() {
    _isOpen ? _closeDropdown() : _openDropdown();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 6),
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) => Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnim.value),
                      child: child,
                    ),
                  ),
                  child: Material(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 240),
                      decoration: BoxDecoration(
                        color: IGColors.bgLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: IGColors.bgLight, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: IGColors.blue.withValues(alpha: .10),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = item == widget.value;
                            return _DropdownItem(
                              label: item,
                              isSelected: isSelected,
                              onTap: () {
                                widget.onChanged(item);
                                _closeDropdown();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 58,
          decoration: BoxDecoration(
            color: _isOpen ? IGColors.bgLight : IGColors.bgLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isOpen ? IGColors.blue : const Color(0xFFDDE3EE),
              width: _isOpen ? 1.8 : 1.2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                Icon(
                  widget.prefixIcon,
                  size: 20,
                  color: _isOpen ? IGColors.blue : const Color(0xFF9AA5B8),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: _isOpen
                            ? IGColors.blue
                            : const Color(0xFF9AA5B8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: IGColors.bgDark,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: _isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _isOpen ? IGColors.blue : const Color(0xFF9AA5B8),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DropdownItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isSelected
                ? const Color(0xFFEFF6FF)
                : _hovered
                ? const Color(0xFFF5F7FA)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: widget.isSelected
                        ? IGColors.blue
                        : const Color(0xFF3A4A5C),
                  ),
                ),
              ),
              if (widget.isSelected)
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: IGColors.blue,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
