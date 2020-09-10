/*
 * Copyright (C) 2020. by perol_notsf, All rights reserved
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pixez/component/sort_group.dart';
import 'package:pixez/generated/l10n.dart';
import 'package:pixez/lighting/lighting_store.dart';
import 'package:pixez/main.dart';
import 'package:pixez/network/api_client.dart';
import 'package:pixez/page/painter/painter_list.dart';

class FollowList extends StatefulWidget {
  final int id;
  final bool isNovel;
  FollowList({Key key, this.id, this.isNovel = false}) : super(key: key);

  @override
  _FollowListState createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    futureGet = () => apiClient.getUserFollowing(widget.id, restrict);
    super.initState();
  }

  FutureGet futureGet;
  String restrict = 'public';
  Widget buildHeader() {
    return Observer(builder: (_) {
      return Visibility(
        visible: int.parse(accountStore.now.userId) == widget.id,
        child: Align(
          alignment: Alignment.topCenter,
          child: SortGroup(
            children: [I18n.of(context).public, I18n.of(context).private],
            onChange: (index) {
              setState(() {
                futureGet = () => apiClient.getUserFollowing(
                    widget.id, index == 0 ? 'public' : 'private');
              });
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PainterList(
          futureGet: futureGet,
          isNovel: widget.isNovel,
          header: Container(
            height: 45,
          ),
        ),
        buildHeader(),
      ],
    );
  }
}
