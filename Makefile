
.PHONY: deploy

deploy: build
	s3cmd -P sync --delete-removed output/* s3://ooc-lang.org/

build:
	bundle exec nanoc
