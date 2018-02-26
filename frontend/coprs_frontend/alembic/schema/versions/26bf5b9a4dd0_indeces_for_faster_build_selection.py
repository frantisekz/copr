"""add some indeces for faster build selection

Revision ID: 26bf5b9a4dd0
Revises: 3576fc77fb31
Create Date: 2018-01-24 13:36:54.465668

"""

# revision identifiers, used by Alembic.
revision = '26bf5b9a4dd0'
down_revision = '3576fc77fb31'

from alembic import op
import sqlalchemy as sa


def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.create_index('build_filter', 'build', ['source_type', 'canceled'], unique=False)
    op.create_index('build_order', 'build', ['is_background', 'id'], unique=False)
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.drop_index('build_order', table_name='build')
    op.drop_index('build_filter', table_name='build')
    ### end Alembic commands ###