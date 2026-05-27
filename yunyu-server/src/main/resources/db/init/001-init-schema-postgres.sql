-- 云屿 / Yunyu
-- 功能：PostgreSQL 数据库初始化脚本，用于创建核心业务表与基础站点配置。
-- 作用：作为第一阶段建库基线，可用于首次安装流程执行。

CREATE TABLE IF NOT EXISTS "user" (
  "id" BIGSERIAL PRIMARY KEY,
  "email" VARCHAR(128) NOT NULL,
  "user_name" VARCHAR(64) NOT NULL,
  "avatar_url" VARCHAR(255) DEFAULT NULL,
  "password" VARCHAR(255) NOT NULL,
  "password_hash" VARCHAR(255) NOT NULL,
  "role" VARCHAR(32) NOT NULL DEFAULT 'USER',
  "status" VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
  "last_login_at" TIMESTAMP DEFAULT NULL,
  "last_login_ip" VARCHAR(64) DEFAULT NULL,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT uk_user_email_deleted UNIQUE ("email", "deleted")
);
CREATE INDEX IF NOT EXISTS idx_user_status_deleted_created_time ON "user" ("status", "deleted", "created_time", "id");
CREATE INDEX IF NOT EXISTS idx_user_created_time ON "user" ("created_time");

CREATE TABLE IF NOT EXISTS "user_auth" (
  "id" BIGSERIAL PRIMARY KEY,
  "user_id" BIGINT NOT NULL,
  "auth_type" VARCHAR(32) NOT NULL,
  "auth_identity" VARCHAR(191) NOT NULL,
  "auth_name" VARCHAR(100) DEFAULT NULL,
  "auth_email" VARCHAR(128) DEFAULT NULL,
  "email_verified" SMALLINT NOT NULL DEFAULT 0,
  "raw_user_info" JSONB DEFAULT NULL,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uk_user_auth_type_identity UNIQUE ("auth_type", "auth_identity"),
  CONSTRAINT uk_user_auth_user_id_type UNIQUE ("user_id", "auth_type")
);
CREATE INDEX IF NOT EXISTS idx_user_auth_email ON "user_auth" ("auth_email");

CREATE TABLE IF NOT EXISTS "category" (
  "id" BIGSERIAL PRIMARY KEY,
  "name" VARCHAR(64) NOT NULL,
  "slug" VARCHAR(120) NOT NULL,
  "description" VARCHAR(255) DEFAULT NULL,
  "cover_url" VARCHAR(255) DEFAULT NULL,
  "sort_order" INT NOT NULL DEFAULT 0,
  "status" VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT uk_category_name_deleted UNIQUE ("name", "deleted"),
  CONSTRAINT uk_category_slug_deleted UNIQUE ("slug", "deleted")
);
CREATE INDEX IF NOT EXISTS idx_category_status_deleted_sort_order ON "category" ("status", "deleted", "sort_order", "id");
CREATE INDEX IF NOT EXISTS idx_category_created_time ON "category" ("created_time");

CREATE TABLE IF NOT EXISTS "tag" (
  "id" BIGSERIAL PRIMARY KEY,
  "name" VARCHAR(64) NOT NULL,
  "slug" VARCHAR(120) NOT NULL,
  "description" VARCHAR(255) DEFAULT NULL,
  "status" VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT uk_tag_name_deleted UNIQUE ("name", "deleted"),
  CONSTRAINT uk_tag_slug_deleted UNIQUE ("slug", "deleted")
);
CREATE INDEX IF NOT EXISTS idx_tag_status_deleted_created_time ON "tag" ("status", "deleted", "created_time", "id");

CREATE TABLE IF NOT EXISTS "topic" (
  "id" BIGSERIAL PRIMARY KEY,
  "name" VARCHAR(100) NOT NULL,
  "slug" VARCHAR(120) NOT NULL,
  "summary" VARCHAR(500) DEFAULT NULL,
  "cover_url" VARCHAR(255) DEFAULT NULL,
  "status" VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
  "sort_order" INT NOT NULL DEFAULT 0,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT uk_topic_name_deleted UNIQUE ("name", "deleted"),
  CONSTRAINT uk_topic_slug_deleted UNIQUE ("slug", "deleted")
);
CREATE INDEX IF NOT EXISTS idx_topic_status_deleted_sort_order ON "topic" ("status", "deleted", "sort_order", "id");

CREATE TABLE IF NOT EXISTS "post" (
  "id" BIGSERIAL PRIMARY KEY,
  "title" VARCHAR(200) NOT NULL,
  "slug" VARCHAR(220) NOT NULL,
  "summary" VARCHAR(500) DEFAULT NULL,
  "cover_url" VARCHAR(255) DEFAULT NULL,
  "user_id" BIGINT NOT NULL,
  "category_id" BIGINT DEFAULT NULL,
  "status" VARCHAR(32) NOT NULL DEFAULT 'DRAFT',
  "is_top" SMALLINT NOT NULL DEFAULT 0,
  "is_recommend" SMALLINT NOT NULL DEFAULT 0,
  "has_video" SMALLINT NOT NULL DEFAULT 0,
  "allow_comment" SMALLINT NOT NULL DEFAULT 1,
  "seo_title" VARCHAR(255) DEFAULT NULL,
  "seo_description" VARCHAR(500) DEFAULT NULL,
  "published_at" TIMESTAMP DEFAULT NULL,
  "sort_order" INT NOT NULL DEFAULT 0,
  "view_count" BIGINT NOT NULL DEFAULT 0,
  "like_count" BIGINT NOT NULL DEFAULT 0,
  "comment_count" BIGINT NOT NULL DEFAULT 0,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT uk_post_slug_deleted UNIQUE ("slug", "deleted")
);
CREATE INDEX IF NOT EXISTS idx_post_publish_list ON "post" ("status", "deleted", "published_at" DESC, "id" DESC);
CREATE INDEX IF NOT EXISTS idx_post_recommend_list ON "post" ("status", "deleted", "is_recommend", "published_at" DESC, "id" DESC);
CREATE INDEX IF NOT EXISTS idx_post_category_publish ON "post" ("category_id", "status", "deleted", "published_at" DESC, "id" DESC);
CREATE INDEX IF NOT EXISTS idx_post_user_manage ON "post" ("user_id", "status", "deleted", "updated_time" DESC, "id" DESC);
CREATE INDEX IF NOT EXISTS idx_post_top_publish ON "post" ("status", "deleted", "is_top", "sort_order", "published_at" DESC, "id" DESC);
CREATE INDEX IF NOT EXISTS idx_post_created_time ON "post" ("created_time");

CREATE TABLE IF NOT EXISTS "post_content" (
  "id" BIGSERIAL PRIMARY KEY,
  "post_id" BIGINT NOT NULL,
  "content_markdown" TEXT NOT NULL,
  "content_html" TEXT NOT NULL,
  "content_plain_text" TEXT DEFAULT NULL,
  "content_toc_json" JSONB DEFAULT NULL,
  "content_access_config_json" JSONB DEFAULT NULL,
  "tail_hidden_content_markdown" TEXT DEFAULT NULL,
  "tail_hidden_content_html" TEXT DEFAULT NULL,
  "video_url" VARCHAR(500) DEFAULT NULL,
  "reading_time" INT NOT NULL DEFAULT 0,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uk_post_content_post_id UNIQUE ("post_id")
);

CREATE TABLE IF NOT EXISTS "post_tag" (
  "id" BIGSERIAL PRIMARY KEY,
  "post_id" BIGINT NOT NULL,
  "tag_id" BIGINT NOT NULL,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uk_post_tag_post_id_tag_id UNIQUE ("post_id", "tag_id")
);

CREATE TABLE IF NOT EXISTS "content_access_grant" (
  "id" BIGSERIAL PRIMARY KEY,
  "scope_type" VARCHAR(32) NOT NULL,
  "scope_id" BIGINT NOT NULL,
  "rule_type" VARCHAR(64) NOT NULL,
  "grant_target_type" VARCHAR(32) NOT NULL,
  "user_id" BIGINT DEFAULT NULL,
  "visitor_id_hash" VARCHAR(128) DEFAULT NULL,
  "granted_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "expire_at" TIMESTAMP NOT NULL,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_scope_type_scope_id_rule_type ON "content_access_grant" ("scope_type", "scope_id", "rule_type");
CREATE INDEX IF NOT EXISTS idx_user_id ON "content_access_grant" ("user_id");
CREATE INDEX IF NOT EXISTS idx_visitor_id_hash ON "content_access_grant" ("visitor_id_hash");
CREATE INDEX IF NOT EXISTS idx_expire_at ON "content_access_grant" ("expire_at");

CREATE TABLE IF NOT EXISTS "topic_post" (
  "id" BIGSERIAL PRIMARY KEY,
  "topic_id" BIGINT NOT NULL,
  "post_id" BIGINT NOT NULL,
  "sort_order" INT NOT NULL DEFAULT 0,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uk_topic_post_topic_id_post_id UNIQUE ("topic_id", "post_id")
);
CREATE INDEX IF NOT EXISTS idx_topic_post_topic_sort ON "topic_post" ("topic_id", "sort_order", "id");
CREATE INDEX IF NOT EXISTS idx_topic_post_post_id ON "topic_post" ("post_id");

CREATE TABLE IF NOT EXISTS "comment" (
  "id" BIGSERIAL PRIMARY KEY,
  "post_id" BIGINT NOT NULL,
  "user_id" BIGINT NOT NULL,
  "reply_comment_id" BIGINT DEFAULT NULL,
  "root_id" BIGINT DEFAULT NULL,
  "content" TEXT NOT NULL,
  "status" VARCHAR(32) NOT NULL DEFAULT 'PENDING',
  "ip" VARCHAR(64) DEFAULT NULL,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" SMALLINT NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_comment_post_status_root_created_time ON "comment" ("post_id", "status", "deleted", "root_id", "created_time", "id");
CREATE INDEX IF NOT EXISTS idx_comment_user_status_created_time ON "comment" ("user_id", "status", "created_time", "id");
CREATE INDEX IF NOT EXISTS idx_comment_reply_comment_id ON "comment" ("reply_comment_id");

CREATE TABLE IF NOT EXISTS "friend_link" (
  "id" BIGSERIAL PRIMARY KEY,
  "site_name" VARCHAR(100) NOT NULL,
  "site_url" VARCHAR(255) NOT NULL,
  "logo_url" VARCHAR(255) DEFAULT NULL,
  "description" VARCHAR(255) DEFAULT NULL,
  "contact_name" VARCHAR(64) DEFAULT NULL,
  "contact_email" VARCHAR(128) DEFAULT NULL,
  "contact_message" VARCHAR(500) DEFAULT NULL,
  "theme_color" VARCHAR(7) DEFAULT NULL,
  "sort_order" INT NOT NULL DEFAULT 0,
  "status" VARCHAR(32) NOT NULL DEFAULT 'PENDING',
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT uk_friend_link_site_name_deleted UNIQUE ("site_name", "deleted"),
  CONSTRAINT uk_friend_link_site_url_deleted UNIQUE ("site_url", "deleted")
);
CREATE INDEX IF NOT EXISTS idx_friend_link_status_deleted_sort_order ON "friend_link" ("status", "deleted", "sort_order", "id");
CREATE INDEX IF NOT EXISTS idx_friend_link_created_time ON "friend_link" ("created_time");

CREATE TABLE IF NOT EXISTS "attachment_file" (
  "id" BIGSERIAL PRIMARY KEY,
  "file_name" VARCHAR(255) NOT NULL,
  "file_ext" VARCHAR(32) DEFAULT NULL,
  "mime_type" VARCHAR(128) NOT NULL,
  "size_bytes" BIGINT NOT NULL,
  "sha256" CHAR(64) NOT NULL,
  "storage_provider" VARCHAR(32) NOT NULL DEFAULT 'S3',
  "storage_config_key" VARCHAR(64) NOT NULL,
  "bucket" VARCHAR(128) NOT NULL,
  "object_key" VARCHAR(255) NOT NULL,
  "access_url" VARCHAR(500) NOT NULL,
  "etag" VARCHAR(128) DEFAULT NULL,
  "uploader_user_id" BIGINT NOT NULL,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT uk_attachment_sha256_deleted UNIQUE ("sha256", "deleted"),
  CONSTRAINT uk_attachment_bucket_object_key_deleted UNIQUE ("bucket", "object_key", "deleted")
);
CREATE INDEX IF NOT EXISTS idx_attachment_uploader_created ON "attachment_file" ("uploader_user_id", "created_time", "id");
CREATE INDEX IF NOT EXISTS idx_attachment_mime_created ON "attachment_file" ("mime_type", "created_time", "id");

CREATE TABLE IF NOT EXISTS "site_config" (
  "id" BIGSERIAL PRIMARY KEY,
  "config_key" VARCHAR(64) NOT NULL,
  "config_name" VARCHAR(100) NOT NULL,
  "config_json" JSONB NOT NULL,
  "remark" VARCHAR(255) DEFAULT NULL,
  "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uk_site_config_config_key UNIQUE ("config_key")
);

INSERT INTO "site_config" ("config_key", "config_name", "config_json", "remark")
VALUES
  ('site.base', '站点基础配置', '{"siteName": "", "siteSubTitle": "", "logoUrl": "", "faviconUrl": "", "footerText": ""}'::jsonb, '初始化占位配置'),
  ('site.seo', '站点SEO配置', '{"defaultTitle": "", "defaultDescription": ""}'::jsonb, '初始化占位配置'),
  ('site.theme', '站点主题配置', '{"primaryColor": "", "secondaryColor": ""}'::jsonb, '初始化占位配置'),
  ('site.content-access', '站点内容访问配置', '{"wechatAccessCodeEnabled": false, "wechatAccessCode": "", "wechatAccessCodeHint": "关注公众号后输入访问验证码", "wechatQrCodeUrl": ""}'::jsonb, '初始化站点内容访问配置'),
  ('homepage_config', '首页配置', '{"heroEnabled": true, "heroLayout": "brand", "heroBackgroundMode": "gradient-grid", "heroEyebrow": "Yunyu / 云屿", "heroTitle": "把热爱、写作与长期观察，整理成一个可以慢慢逛的内容站", "heroSubtitle": "记录技术、审美、创作与阅读的个人博客与内容网站", "heroPrimaryButtonText": "查看文章", "heroPrimaryButtonLink": "/posts", "heroSecondaryButtonText": "进入专题", "heroSecondaryButtonLink": "/topics", "heroVisualPostId": null, "heroVisualClickable": true, "heroKeywords": ["写作", "技术", "审美", "长期主义"], "showHeroKeywords": true, "showHeroStats": true, "heroStats": [], "showFeaturedSection": true, "featuredSectionTitle": "主打内容", "showLatestSection": true, "latestSectionTitle": "最新文章", "showCategorySection": true, "categorySectionTitle": "分类", "showTopicSection": true, "topicSectionTitle": "专题"}'::jsonb, '首页无封面首屏配置'),
  ('site.feature', '站点功能开关', '{"allowRegister": false, "allowComment": true, "enableSearch": false, "enableSubscribe": false}'::jsonb, '初始化占位配置')
ON CONFLICT ("config_key") DO UPDATE SET
  "config_name" = EXCLUDED."config_name",
  "config_json" = EXCLUDED."config_json",
  "remark" = EXCLUDED."remark",
  "updated_time" = CURRENT_TIMESTAMP;

-- 创建触发器函数用于自动更新 updated_time
CREATE OR REPLACE FUNCTION update_updated_time_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_time = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为所有表添加 updated_time 触发器
CREATE TRIGGER update_user_updated_time BEFORE UPDATE ON "user" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_user_auth_updated_time BEFORE UPDATE ON "user_auth" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_category_updated_time BEFORE UPDATE ON "category" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_tag_updated_time BEFORE UPDATE ON "tag" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_topic_updated_time BEFORE UPDATE ON "topic" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_post_updated_time BEFORE UPDATE ON "post" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_post_content_updated_time BEFORE UPDATE ON "post_content" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_content_access_grant_updated_time BEFORE UPDATE ON "content_access_grant" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_comment_updated_time BEFORE UPDATE ON "comment" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_friend_link_updated_time BEFORE UPDATE ON "friend_link" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_attachment_file_updated_time BEFORE UPDATE ON "attachment_file" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
CREATE TRIGGER update_site_config_updated_time BEFORE UPDATE ON "site_config" FOR EACH ROW EXECUTE FUNCTION update_updated_time_column();
