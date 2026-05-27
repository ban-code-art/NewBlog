-- 云屿 / Yunyu
-- 功能：初始化一批可用于本地开发、联调和前台演示的测试数据。
-- 作用：补充动漫内容站风格的用户、分类、标签、专题、文章、正文、评论与站点配置。

DELETE FROM "comment";
DELETE FROM "friend_link";
DELETE FROM "topic_post";
DELETE FROM "post_tag";
DELETE FROM "post_content";
DELETE FROM "post";
DELETE FROM "topic";
DELETE FROM "tag";
DELETE FROM "category";
DELETE FROM "user_auth";
DELETE FROM "user";

-- Reset sequences
ALTER SEQUENCE user_id_seq RESTART WITH 1;
ALTER SEQUENCE user_auth_id_seq RESTART WITH 1;
ALTER SEQUENCE category_id_seq RESTART WITH 1;
ALTER SEQUENCE tag_id_seq RESTART WITH 1;
ALTER SEQUENCE topic_id_seq RESTART WITH 1;
ALTER SEQUENCE post_id_seq RESTART WITH 1;
ALTER SEQUENCE post_content_id_seq RESTART WITH 1;
ALTER SEQUENCE post_tag_id_seq RESTART WITH 1;
ALTER SEQUENCE topic_post_id_seq RESTART WITH 1;
ALTER SEQUENCE comment_id_seq RESTART WITH 1;
ALTER SEQUENCE friend_link_id_seq RESTART WITH 1;

INSERT INTO "user" (
  "id", "email", "user_name", "avatar_url", "password", "password_hash", "role", "status",
  "last_login_at", "last_login_ip", "created_time", "updated_time", "deleted"
)
VALUES
  (
    1,
    'admin@yunyu.local',
    '星野澄',
    'https://image.pollinations.ai/prompt/anime%20girl%20portrait%20clean%20soft%20light?width=512&height=512&seed=3201&nologo=true',
    'Admin@123456',
    '$2a$10$admin.demo.hash.value',
    'SUPER_ADMIN',
    'ACTIVE',
    '2026-03-31 22:15:00',
    '127.0.0.1',
    '2026-03-01 09:00:00',
    '2026-03-31 22:15:00',
    0
  ),
  (
    2,
    'editor@yunyu.local',
    '雾岛栞',
    'https://image.pollinations.ai/prompt/anime%20editor%20portrait%20blue%20hair%20illustration?width=512&height=512&seed=3202&nologo=true',
    'Editor@123456',
    '$2a$10$editor.demo.hash.value',
    'USER',
    'ACTIVE',
    '2026-03-30 19:40:00',
    '127.0.0.1',
    '2026-03-02 10:00:00',
    '2026-03-30 19:40:00',
    0
  ),
  (
    3,
    'reader@yunyu.local',
    '朝雾未央',
    'https://image.pollinations.ai/prompt/anime%20girl%20portrait%20warm%20sunset%20illustration?width=512&height=512&seed=3203&nologo=true',
    'Reader@123456',
    '$2a$10$reader.demo.hash.value',
    'USER',
    'ACTIVE',
    '2026-03-29 21:10:00',
    '127.0.0.1',
    '2026-03-03 11:00:00',
    '2026-03-29 21:10:00',
    0
  );

INSERT INTO "user_auth" (
  "id", "user_id", "auth_type", "auth_identity", "auth_name", "auth_email",
  "email_verified", "raw_user_info", "created_time", "updated_time"
)
VALUES
  (
    1, 1, 'LOCAL', 'admin@yunyu.local', '星野澄', 'admin@yunyu.local',
    1, '{"source": "seed", "role": "SUPER_ADMIN"}'::jsonb,
    '2026-03-01 09:00:00', '2026-03-31 22:15:00'
  ),
  (
    2, 2, 'LOCAL', 'editor@yunyu.local', '雾岛栞', 'editor@yunyu.local',
    1, '{"source": "seed", "role": "EDITOR"}'::jsonb,
    '2026-03-02 10:00:00', '2026-03-30 19:40:00'
  ),
  (
    3, 3, 'LOCAL', 'reader@yunyu.local', '朝雾未央', 'reader@yunyu.local',
    1, '{"source": "seed", "role": "READER"}'::jsonb,
    '2026-03-03 11:00:00', '2026-03-29 21:10:00'
  );

INSERT INTO "category" (
  "id", "name", "slug", "description", "cover_url", "sort_order", "status",
  "created_time", "updated_time", "deleted"
)
VALUES
  (
    1,
    '新番观察',
    'season-watch',
    '追踪季度新番、口碑变化与值得补完的作品。',
    'https://image.pollinations.ai/prompt/anime%20spring%20season%20illustration%20sky?width=1200&height=675&seed=1101&nologo=true',
    10,
    'ACTIVE',
    '2026-03-01 10:00:00',
    '2026-03-20 10:00:00',
    0
  ),
  (
    2,
    '场景美学',
    'scene-aesthetics',
    '收录城市夜景、海边列车、教室与天台等高情绪场景。',
    'https://image.pollinations.ai/prompt/anime%20city%20night%20aesthetic%20illustration?width=1200&height=675&seed=1102&nologo=true',
    20,
    'ACTIVE',
    '2026-03-01 10:05:00',
    '2026-03-20 10:05:00',
    0
  ),
  (
    3,
    '角色档案',
    'character-file',
    '整理角色设定、成长线与名场面表现。',
    'https://image.pollinations.ai/prompt/anime%20character%20design%20sheet%20illustration?width=1200&height=675&seed=1103&nologo=true',
    30,
    'ACTIVE',
    '2026-03-01 10:10:00',
    '2026-03-20 10:10:00',
    0
  ),
  (
    4,
    '音乐与配乐',
    'music-score',
    '围绕片头曲、片尾曲与氛围配乐做内容整理。',
    'https://image.pollinations.ai/prompt/anime%20music%20studio%20illustration%20soft%20light?width=1200&height=675&seed=1104&nologo=true',
    40,
    'ACTIVE',
    '2026-03-01 10:15:00',
    '2026-03-20 10:15:00',
    0
  ),
  (
    5,
    '入坑指南',
    'starter-guide',
    '面向新读者的观看路线、补番顺序和风格推荐。',
    'https://image.pollinations.ai/prompt/anime%20library%20guide%20illustration%20warm?width=1200&height=675&seed=1105&nologo=true',
    50,
    'ACTIVE',
    '2026-03-01 10:20:00',
    '2026-03-20 10:20:00',
    0
  );

INSERT INTO "tag" (
  "id", "name", "slug", "description", "status", "created_time", "updated_time", "deleted"
)
VALUES
  (1, '治愈系', 'healing', '偏温柔、慢节奏、舒缓情绪的内容。', 'ACTIVE', '2026-03-01 11:00:00', '2026-03-21 09:00:00', 0),
  (2, '都市夜景', 'city-night', '城市霓虹、夜色和雨幕氛围。', 'ACTIVE', '2026-03-01 11:05:00', '2026-03-21 09:05:00', 0),
  (3, '校园', 'campus', '教室、社团、青春关系线。', 'ACTIVE', '2026-03-01 11:10:00', '2026-03-21 09:10:00', 0),
  (4, '奇幻冒险', 'fantasy-adventure', '架空世界与成长旅程。', 'ACTIVE', '2026-03-01 11:15:00', '2026-03-21 09:15:00', 0),
  (5, '配乐精选', 'soundtrack', '围绕 OP/ED 和配乐名场面展开。', 'ACTIVE', '2026-03-01 11:20:00', '2026-03-21 09:20:00', 0),
  (6, '角色成长', 'character-growth', '角色自我完成与关系变化。', 'ACTIVE', '2026-03-01 11:25:00', '2026-03-21 09:25:00', 0),
  (7, '壁纸向', 'wallpaper', '适合作为封面和视觉收藏的内容。', 'ACTIVE', '2026-03-01 11:30:00', '2026-03-21 09:30:00', 0),
  (8, '新手入门', 'beginner', '帮助新读者快速进入作品语境。', 'ACTIVE', '2026-03-01 11:35:00', '2026-03-21 09:35:00', 0);

INSERT INTO "topic" (
  "id", "name", "slug", "summary", "cover_url", "status", "sort_order",
  "created_time", "updated_time", "deleted"
)
VALUES
  (
    1,
    '2026 春季追番清单',
    'spring-2026-watchlist',
    '用一页内容看完春季新番里最值得先追的作品与观看理由。',
    'https://image.pollinations.ai/prompt/anime%20spring%20watchlist%20cover%20illustration?width=1200&height=675&seed=2101&nologo=true',
    'ACTIVE',
    10,
    '2026-03-05 10:00:00',
    '2026-03-26 10:00:00',
    0
  ),
  (
    2,
    '城市夜色美学',
    'city-night-aesthetics',
    '把最有氛围感的电车窗景、雨夜路口和天台夜风都收进一个专题。',
    'https://image.pollinations.ai/prompt/anime%20night%20city%20aesthetic%20cover?width=1200&height=675&seed=2102&nologo=true',
    'ACTIVE',
    20,
    '2026-03-05 10:10:00',
    '2026-03-26 10:10:00',
    0
  ),
  (
    3,
    '入坑路线图',
    'starter-roadmap',
    '给第一次接触动画内容站的新读者准备的阅读路线与分类导航。',
    'https://image.pollinations.ai/prompt/anime%20starter%20guide%20map%20illustration?width=1200&height=675&seed=2103&nologo=true',
    'ACTIVE',
    30,
    '2026-03-05 10:20:00',
    '2026-03-26 10:20:00',
    0
  );

INSERT INTO "post" (
  "id", "title", "slug", "summary", "cover_url", "user_id", "category_id", "status",
  "is_top", "is_recommend", "has_video", "allow_comment", "seo_title", "seo_description",
  "published_at", "sort_order", "view_count", "like_count", "comment_count",
  "created_time", "updated_time", "deleted"
)
VALUES
  (
    1,
    '2026 春季新番先看哪 5 部：从情绪密度到作画稳定度的一次筛选',
    'spring-2026-first-five',
    '如果你只想先追 5 部作品，这篇会按情绪浓度、画面完成度和追更压力给出最稳妥的入场顺序。',
    'https://image.pollinations.ai/prompt/anime%20spring%20festival%20key%20visual?width=1600&height=900&seed=4101&nologo=true',
    1,
    1,
    'PUBLISHED',
    1,
    1,
    0,
    1,
    '2026 春季新番先看哪 5 部',
    '按情绪密度、作画稳定度和追更压力整理出的 2026 春季新番入门推荐。',
    '2026-03-27 20:00:00',
    90,
    4821,
    326,
    3,
    '2026-03-25 14:00:00',
    '2026-03-27 20:00:00',
    0
  ),
  (
    2,
    '雨夜电车窗景为什么总能打动人：12 个高情绪城市镜头拆解',
    'rainy-city-train-scenes',
    '从霓虹倒影、玻璃反光和人物留白三个角度，拆解动画中最容易让人沉浸的城市夜景镜头。',
    'https://image.pollinations.ai/prompt/anime%20rainy%20city%20train%20window%20illustration?width=1600&height=900&seed=4102&nologo=true',
    2,
    2,
    'PUBLISHED',
    0,
    1,
    0,
    1,
    '雨夜电车窗景镜头拆解',
    '拆解动画里最有氛围感的雨夜电车与城市夜景镜头语言。',
    '2026-03-26 21:10:00',
    80,
    3680,
    281,
    2,
    '2026-03-24 16:10:00',
    '2026-03-26 21:10:00',
    0
  ),
  (
    3,
    '从"温柔而坚定"到"终于开口"：本季最完整的角色成长线',
    'character-growth-arc',
    '这篇围绕一条完整成长线，记录角色从沉默到表达、从观望到行动的关键节点。',
    'https://image.pollinations.ai/prompt/anime%20character%20growth%20storyboard%20illustration?width=1600&height=900&seed=4103&nologo=true',
    2,
    3,
    'PUBLISHED',
    0,
    1,
    0,
    1,
    '角色成长线观察',
    '记录一个角色从沉默到表达的完整成长节奏与名场面。',
    '2026-03-24 20:30:00',
    70,
    2950,
    214,
    1,
    '2026-03-22 09:30:00',
    '2026-03-24 20:30:00',
    0
  ),
  (
    4,
    '一张配乐单就够了：适合深夜循环播放的 8 首动画氛围曲',
    'midnight-anime-soundtracks',
    '当你只想在夜里开着台灯慢慢听，这 8 首动画配乐能把整个房间都变得柔软下来。',
    'https://image.pollinations.ai/prompt/anime%20music%20room%20night%20illustration?width=1600&height=900&seed=4104&nologo=true',
    1,
    4,
    'PUBLISHED',
    0,
    0,
    0,
    1,
    '深夜循环播放的动画氛围曲',
    '适合夜里循环播放的动画配乐精选，覆盖片头、片尾和背景音乐。',
    '2026-03-22 22:00:00',
    60,
    2234,
    168,
    1,
    '2026-03-20 11:00:00',
    '2026-03-22 22:00:00',
    0
  ),
  (
    5,
    '第一次来云屿应该怎么逛：分类、专题、标签三条主线一次看懂',
    'how-to-use-yunyu',
    '如果你是第一次进入这个站点，这篇会告诉你最省心的阅读路径与内容组织方式。',
    'https://image.pollinations.ai/prompt/anime%20guide%20board%20illustration%20library?width=1600&height=900&seed=4105&nologo=true',
    1,
    5,
    'PUBLISHED',
    0,
    1,
    0,
    1,
    '第一次来云屿应该怎么逛',
    '帮助新用户快速看懂云屿的分类、标签和专题体系。',
    '2026-03-21 19:20:00',
    50,
    1890,
    141,
    4,
    '2026-03-19 15:20:00',
    '2026-03-21 19:20:00',
    0
  ),
  (
    6,
    '海边列车、黄昏天台和放学路口：适合做壁纸的 9 个动画场景',
    'nine-anime-wallpaper-scenes',
    '这一篇不做剧情分析，只挑那些一眼就想保存下来的场景镜头。',
    'https://image.pollinations.ai/prompt/anime%20seaside%20train%20sunset%20illustration?width=1600&height=900&seed=4106&nologo=true',
    3,
    2,
    'PUBLISHED',
    0,
    1,
    0,
    1,
    '适合做壁纸的动画场景',
    '海边列车、黄昏天台和放学路口等适合收藏做壁纸的高颜值场景。',
    '2026-03-20 20:10:00',
    40,
    4110,
    356,
    2,
    '2026-03-18 08:40:00',
    '2026-03-20 20:10:00',
    0
  );

-- __CONTINUE_HERE__
